
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/task_bloc.dart';
import '../../blocs/timer_bloc.dart';
import '../../blocs/update_task_status.dart';
import '../../models/task.dart';
import '../../repository/task_repository.dart';
import '../../services/timer_service.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final BuildContext keepContext;

  const TaskCard({super.key, required this.task, required this.keepContext});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text(task.title),
            Text(task.description),
            if (task.status == "Done")
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Icon(Icons.timer, color: Colors.green),
                  Flexible(
                    child: Text('Timer: ${task.elapsedTime.inSeconds} seconds'),
                  ),
                ],
              ),
            if (task.status == "In Progress")
              BlocProvider(
                create: (context) => TimerBloc(TimerService()),
                child: BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, timerState) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (timerState is TimerInitial ||
                                timerState is TimerStopped) {
                              BlocProvider.of<TimerBloc>(context)
                                  .add(StartTimerEvent());
                            } else if (timerState is TimerRunning) {
                              BlocProvider.of<TimerBloc>(context)
                                  .add(StopTimerEvent());
                              var timer = await timerState.elapsedTime.inSeconds;
                              final elapsedTime =
                                  BlocProvider.of<TimerBloc>(context)
                                      .state
                                      .elapsedTime;
                              final updatedTask =
                              task.copyWith(elapsedTime: elapsedTime);
                              BlocProvider.of<TaskBloc>(keepContext).add(
                                  UpdateTaskStatus(updatedTask, "Done",
                                      elapsedTime: elapsedTime));
                            }
                          },
                          child: Text(
                            timerState is TimerRunning
                                ? 'Stop Timer'
                                : 'Start Timer',
                            softWrap: false,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(Icons.timer, color: Colors.orangeAccent),
                            Flexible(
                              child: Text(
                                  'Timer: ${timerState.elapsedTime.inSeconds} seconds'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                task.status == "To Do"
                    ? IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle task editing
                    editTask(context, task.title);
                  },
                )
                    : IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // Handle task editing
                  },
                )
              ],
            )
          ]),
        ));
  }

  void editTask(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController taskNameController =
        TextEditingController();
        taskNameController.text = title;
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: taskNameController,
            decoration: const InputDecoration(hintText: 'Enter task name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final taskName = taskNameController.text;
                if (taskName.isNotEmpty) {
                  final updateTask =
                  await TaskRepository().updateTask(taskName, task.id);
                  BlocProvider.of<TaskBloc>(keepContext)
                      .add(EditTasksEvent(updateTask));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Task "$taskName" Updated successfully'),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
