part of 'run_timer_bloc.dart';

@immutable
abstract class RunTimerState {
  final Duration elapsed;

  RunTimerState({this.elapsed = Duration.zero});
}

class RunTimerInitial extends RunTimerState {
  RunTimerInitial({Duration elapsed = Duration.zero}) : super(elapsed: elapsed);
}

class RunTimerRunning extends RunTimerState {
  RunTimerRunning({Duration elapsed}) : super(elapsed: elapsed);
}

class RunTimerStopped extends RunTimerState {
  RunTimerStopped({Duration elapsed}) : super(elapsed: elapsed);
}
