// File: lib/screens/task_details.dart
import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  final String taskTitle;
  final int taskDuration;

  const TaskDetailsScreen(
      {super.key,
      required this.taskId,
      required this.taskTitle,
      required this.taskDuration});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Task Title: ${widget.taskTitle}'),
            Text('Task ID: ${widget.taskId}'),
            Text('Time Spent: ${widget.taskDuration}s'),
          ],
        ),
      ),
    );
  }
}
