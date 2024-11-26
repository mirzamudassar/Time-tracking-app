// File: lib/blocs/task_bloc.dart

import 'package:time_tracking_app/blocs/task_bloc.dart';

import '../models/task.dart';

class UpdateTaskStatus extends TaskEvent {
  final Task task;
  final String newStatus;
  final Duration elapsedTime;

  UpdateTaskStatus(this.task, this.newStatus, {this.elapsedTime = Duration.zero});
}
