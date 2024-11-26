// File: lib/screens/kanban_board.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/blocs/task_bloc.dart';
import 'package:time_tracking_app/models/task.dart';
import 'package:time_tracking_app/screens/widgets/task_card.dart';
import 'package:time_tracking_app/screens/task_details.dart';
import '../blocs/timer_bloc.dart';
import '../blocs/update_task_status.dart';
import '../local_db/DatabaseHelper.dart';
import '../repository/task_repository.dart';
import '../services/timer_service.dart';
import 'widgets/kanban_board_widget.dart';

class KanbanBoardScreen extends StatelessWidget {
  var keepContext;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        taskRepository: TaskRepository(),
      )..add(FetchTasksEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Kanban Board')),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              keepContext = context;
              return KanbanBoard(tasks: state.tasks, keepContext: keepContext);
            } else {
              return const Center(child: Text('No tasks found.'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController taskNameController =
                    TextEditingController();
                return AlertDialog(
                  title: const Text('Add New Task'),
                  content: TextField(
                    controller: taskNameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter task name'),
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
                          final newTask =
                              await TaskRepository().createTask(taskName);
                          BlocProvider.of<TaskBloc>(keepContext)
                              .add(CreateTasksEvent(newTask));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Task "$taskName" added successfully'),
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
