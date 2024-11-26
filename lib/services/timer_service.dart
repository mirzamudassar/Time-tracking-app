// File: lib/services/timer_service.dart

class TimerService {
  Duration _elapsedTime = Duration.zero;
  late final Stopwatch _stopwatch;

  TimerService() {
    _stopwatch = Stopwatch();
  }

  Duration get elapsedTime => _elapsedTime;

  void start() {
    _stopwatch.start();
  }

  Duration stop() {
    _stopwatch.stop();
    _elapsedTime = _stopwatch.elapsed;
    return _elapsedTime;
  }

  void reset() {
    _stopwatch.reset();
    _elapsedTime = Duration.zero;
  }
}