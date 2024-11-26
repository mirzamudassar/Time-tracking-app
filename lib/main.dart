// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'injection.dart';
import 'blocs/task_bloc.dart';

void main() {
  configureDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = AppRouter.router;

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: 'Time Tracker App',
        theme: ThemeData.light(),
      );
  }
}