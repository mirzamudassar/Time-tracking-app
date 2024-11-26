// File: lib/blocs/timer_event.dart
part of 'timer_bloc.dart';


abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class StartTimerEvent extends TimerEvent {}

class StopTimerEvent extends TimerEvent {}

class ResetTimerEvent extends TimerEvent {}