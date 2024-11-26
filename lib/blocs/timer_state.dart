// File: lib/blocs/timer_state.dart
part of 'timer_bloc.dart';

abstract class TimerState {
  final Duration elapsedTime;

  TimerState(this.elapsedTime);
}

class TimerInitial extends TimerState {
  TimerInitial() : super(Duration.zero);
}

class TimerRunning extends TimerState {
  TimerRunning(Duration elapsedTime) : super(elapsedTime);
}

class TimerStopped extends TimerState {
  TimerStopped(Duration elapsedTime) : super(elapsedTime);
}