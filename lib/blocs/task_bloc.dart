import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/blocs/update_task_status.dart';
import '../models/task.dart';
import '../repository/task_repository.dart';

abstract class TaskEvent {}

class FetchTasksEvent extends TaskEvent {}

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<FetchTasksEvent>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await taskRepository.fetchTasks();
        emit(TaskLoaded(tasks));
      } catch (_) {
        emit(TaskInitial());
      }
    });
    on<CreateTasksEvent>((event, emit) async {
      try {
        // Add the task to the repository
        final newTask = await taskRepository.createTask(event.task.title);
        if (state is TaskLoaded) {
          // Add the new task to the existing list
          final updatedTasks = List<Task>.from((state as TaskLoaded).tasks)
            ..add(newTask);
          emit(TaskLoaded(updatedTasks));
        }
      } catch (error) {
        emit(TaskInitial()); // Or handle errors appropriately
      }
    });
    on<EditTasksEvent>((event, emit) async {
      try {
        // Add the task to the repository
        final updatedTask =
            await taskRepository.updateTask(event.task.title, event.task.id);
        if (state is TaskLoaded) {
          // Update the task in the existing list
          final updatedTasks = (state as TaskLoaded).tasks.map((task) {
            return task.id == updatedTask.id ? updatedTask : task;
          }).toList();
          emit(TaskLoaded(updatedTasks));
        }
      } catch (error) {
        emit(TaskInitial()); // Or handle errors appropriately
      }
    });

    /* on<UpdateTaskStatus>((event, emit) async {
      try {
        final isCompleted = event.newStatus == "Done";
        // await taskRepository.updateTaskStatus(event.task.id, isCompleted);
        // Update the task in the state
        final currentState = state;
        if (currentState is TaskLoaded) {
          final updatedTasks = currentState.tasks.map((task) {
            if (task.id == event.task.id) {
              return task.copyWith(status: event.newStatus);
            }
            return task;
          }).toList();
          emit(TaskLoaded(updatedTasks));
        }
      } catch (_) {
        emit(TaskInitial());
      }
    });*/
    on<UpdateTaskStatus>((event, emit) async {
      try {
        final isCompleted = event.newStatus == "Done";
        final currentState = state;
        if (currentState is TaskLoaded) {
          final updatedTasks = currentState.tasks.map((task) {
            if (task.id == event.task.id) {
              return task.copyWith(
                status: event.newStatus,
                elapsedTime: event.newStatus == "Done"
                    ? event.elapsedTime
                    : task.elapsedTime,
              );
            }
            return task;
          }).toList();
          emit(TaskLoaded(updatedTasks));
        }
      } catch (_) {
        emit(TaskInitial());
      }
    });
  }
}

class EditTasksEvent extends TaskEvent {
  final Task task;

  EditTasksEvent(this.task);

  @override
  List<Object> get props => [task];
}

class CreateTasksEvent extends TaskEvent {
  final Task task;

  CreateTasksEvent(this.task);

  @override
  List<Object> get props => [task];
}
