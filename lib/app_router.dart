// File: lib/app_router.dart
import 'package:go_router/go_router.dart';
import 'screens/kanban_board.dart';
import 'screens/task_details.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>  KanbanBoardScreen(),
      ),
      GoRoute(
        path: '/task-details/:id',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return TaskDetailsScreen(taskId: taskId, taskTitle: 'Task $taskId', taskDuration: 0);
        },
      ),
    ],
  );
}
