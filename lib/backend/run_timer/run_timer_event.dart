part of 'run_timer_bloc.dart';

@immutable
abstract class RunTimerEvent {}

class RunTimerEventStart extends RunTimerEvent {}

class RunTimerEventStop extends RunTimerEvent {}

class RunTimerEventReset extends RunTimerEvent {}

class RunTimerEventTick extends RunTimerEvent {}
