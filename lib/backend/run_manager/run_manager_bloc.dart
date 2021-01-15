import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_eye_tracker/backend/tcp_server.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:flutter_eye_tracker/model/run.dart';
import 'package:meta/meta.dart';

part 'run_manager_event.dart';
part 'run_manager_state.dart';

class RunManagerBloc extends Bloc<RunManagerEvent, RunManagerState> {
  RunManagerBloc() : super(RunManagerInitial());
  RunBuilder _runBuilder;
  bool _isRunning = false;
  StreamSubscription _streamSubscription;

  @override
  Stream<RunManagerState> mapEventToState(
    RunManagerEvent event,
  ) async* {
    switch (event.runtimeType) {
      case RunManagerStartRun:
        if (!_isRunning) {
          _runBuilder = RunBuilder();
          _runBuilder.start();
          _isRunning = true;
          _streamSubscription = TCPServer.on<GazeData>()
              .listen((e) => {add(RunManagerAddGazeData(e))});
          yield RunManagerRunning(_runBuilder);
        }
        break;
      case RunManagerAddGazeData:
        if (_isRunning) {
          _runBuilder.addGazeData((event as RunManagerAddGazeData).gazeData);
          yield RunManagerRunning(_runBuilder);
        }
        break;
      case RunManagerStopRun:
        if (_isRunning) {
          _runBuilder.stop();
          _isRunning = false;
          if (_streamSubscription != null) {
            _streamSubscription.cancel();
            _streamSubscription = null;
          }
          yield RunManagerRunStopped(_runBuilder);
        }
        break;
      case RunManagerClearRun:
        _isRunning = false;
        if (_streamSubscription != null) {
          _streamSubscription.cancel();
          _streamSubscription = null;
        }
        yield RunManagerNoRun();
        break;
    }
  }
}
