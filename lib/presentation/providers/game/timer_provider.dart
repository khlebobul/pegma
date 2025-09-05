import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_provider.g.dart';

class TimerState {
  final Duration elapsed;
  final bool isRunning;
  final DateTime? startTime;
  final Duration pausedDuration;

  const TimerState({
    this.elapsed = Duration.zero,
    this.isRunning = false,
    this.startTime,
    this.pausedDuration = Duration.zero,
  });

  TimerState copyWith({
    Duration? elapsed,
    bool? isRunning,
    DateTime? startTime,
    Duration? pausedDuration,
  }) {
    return TimerState(
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
      startTime: startTime ?? this.startTime,
      pausedDuration: pausedDuration ?? this.pausedDuration,
    );
  }

  String get formattedTime {
    final totalSeconds = elapsed.inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  Duration getCurrentElapsed() {
    if (!isRunning || startTime == null) return elapsed;
    final now = DateTime.now();
    final totalTime = now.difference(startTime!);
    return totalTime - pausedDuration;
  }
}

@riverpod
class TimerNotifier extends _$TimerNotifier {
  Timer? _timer;
  DateTime? _pauseStartTime;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    return const TimerState();
  }

  void startTimer() {
    if (state.isRunning) return;

    final now = DateTime.now();

    if (state.startTime != null) {
      Duration additionalPausedTime = Duration.zero;
      if (_pauseStartTime != null) {
        additionalPausedTime = now.difference(_pauseStartTime!);
      }

      state = state.copyWith(
        isRunning: true,
        pausedDuration: state.pausedDuration + additionalPausedTime,
      );
    } else {
      state = state.copyWith(
        isRunning: true,
        startTime: now,
        elapsed: Duration.zero,
        pausedDuration: Duration.zero,
      );
    }

    _pauseStartTime = null;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void pauseTimer() {
    if (!state.isRunning) return;

    _timer?.cancel();
    _pauseStartTime = DateTime.now();

    final currentElapsed = state.getCurrentElapsed();
    state = state.copyWith(isRunning: false, elapsed: currentElapsed);
  }

  void stopTimer() {
    _timer?.cancel();
    _pauseStartTime = null;

    state = const TimerState();
  }

  void resetTimer() {
    _timer?.cancel();
    _pauseStartTime = null;

    state = const TimerState();
  }

  void _onTick(Timer timer) {
    if (!state.isRunning) {
      timer.cancel();
      return;
    }

    final currentElapsed = state.getCurrentElapsed();
    state = state.copyWith(elapsed: currentElapsed);
  }

  void loadSavedTime(Duration savedTime) {
    state = state.copyWith(elapsed: savedTime);
  }

  Duration getCurrentElapsedTime() {
    return state.isRunning ? state.getCurrentElapsed() : state.elapsed;
  }
}
