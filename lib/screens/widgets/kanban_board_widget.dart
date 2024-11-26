import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/screens/widgets/task_card.dart';
import 'package:time_tracking_app/screens/task_details.dart';

import '../../blocs/task_bloc.dart';
import '../../blocs/timer_bloc.dart';
import '../../blocs/update_task_status.dart';
import '../../local_db/DatabaseHelper.dart';
import '../../models/task.dart';

class KanbanBoard extends StatelessWidget {
  final List<Task> tasks;
  final BuildContext keepContext;
  final List<String> statuses = ["To Do", "In Progress", "Done"];

  KanbanBoard({required this.tasks, required this.keepContext});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: statuses
          .map((status) => _buildKanbanColumn(context, status))
          .toList(),
    );
  }

  Widget _buildKanbanColumn(BuildContext context, String status) {
    final tasksForStatus =
        tasks.where((task) => task.status == status).toList();
    return Expanded(
      child: Column(
        children: [
          Text(status, style: Theme.of(context).textTheme.headlineSmall),
          Expanded(
            child: DragTarget<Task>(
              onAcceptWithDetails: (details) async {
                final oldStatus = details.data.status;
                final newStatus = status;
                final dbHelper = DatabaseHelper();
                final updatedTask = details.data.copyWith(
                    status: newStatus, elapsedTime: details.data.elapsedTime);
                if (oldStatus == "To Do" && newStatus == "In Progress") {
                  await dbHelper.insertTask(updatedTask);
                } else if (oldStatus == "In Progress" && newStatus == "Done") {
                  // BlocProvider.of<TimerBloc>(context).add(StopTimerEvent());
                  final elapsedTime =
                      BlocProvider.of<TimerBloc>(context).state.elapsedTime;
                  final updatedTask = details.data
                      .copyWith(status: newStatus, elapsedTime: elapsedTime);
                  await dbHelper.updateTask(updatedTask);
                }
                BlocProvider.of<TaskBloc>(context).add(UpdateTaskStatus(
                    details.data, status,
                    elapsedTime: details.data.elapsedTime));
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: tasksForStatus.length,
                    itemBuilder: (context, index) {
                      return LongPressDraggable<Task>(
                        data: tasksForStatus[index],
                        feedback: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width /
                                statuses.length,
                            child: TaskCard(
                                task: tasksForStatus[index],
                                keepContext: keepContext),
                          ),
                        ),
                        childWhenDragging: Container(),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskDetailsScreen(
                                        taskId: tasksForStatus[index].id,
                                        taskTitle: tasksForStatus[index].title,
                                        taskDuration: tasksForStatus[index]
                                            .elapsedTime
                                            .inSeconds,
                                      )),
                            );
                          },
                          child: TaskCard(
                              task: tasksForStatus[index],
                              keepContext: keepContext),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
