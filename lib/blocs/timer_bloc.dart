// File: lib/blocs/timer_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_tracking_app/services/timer_service.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final TimerService _timerService;
  Duration _elapsedTime = Duration.zero;

  TimerBloc(this._timerService) : super(TimerInitial()) {
    on<StartTimerEvent>((event, emit) {
      _timerService.start();
      emit(TimerRunning(_elapsedTime));
    });

    on<StopTimerEvent>((event, emit) {
      _elapsedTime = _timerService.stop();
      emit(TimerStopped(_elapsedTime));
    });

    on<ResetTimerEvent>((event, emit) {
      _elapsedTime = Duration.zero;
      _timerService.reset();
      emit(TimerInitial());
    });
  }

  Duration get elapsedTime => _elapsedTime;
}