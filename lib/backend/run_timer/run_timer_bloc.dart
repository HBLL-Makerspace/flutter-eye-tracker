import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'run_timer_event.dart';
part 'run_timer_state.dart';

class RunTimerBloc extends Bloc<RunTimerEvent, RunTimerState> {
  RunTimerBloc() : super(RunTimerInitial());

  Stopwatch _stopwatch = Stopwatch();
  Timer _timer;

  @override
  Stream<RunTimerState> mapEventToState(
    RunTimerEvent event,
  ) async* {
    switch (event.runtimeType) {
      case RunTimerEventStart:
        if (!(_timer?.isActive ?? false)) {
          _stopwatch.start();
          _timer = Timer.periodic(Duration(milliseconds: 35), (timer) {
            add(RunTimerEventTick());
          });
        }
        break;
      case RunTimerEventStop:
        _timer.cancel();
        _stopwatch.stop();
        yield RunTimerStopped(elapsed: _stopwatch.elapsed);
        break;
      case RunTimerEventReset:
        _timer.cancel();
        _stopwatch.stop();
        yield RunTimerStopped(elapsed: Duration.zero);
        break;
      case RunTimerEventTick:
        yield RunTimerRunning(elapsed: _stopwatch.elapsed);
    }
  }
}
