import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:meta/meta.dart';

part 'run_manager_event.dart';
part 'run_manager_state.dart';

class RunManagerBloc extends Bloc<RunManagerEvent, RunManagerState> {
  RunManagerBloc() : super(RunManagerInitial());

  @override
  Stream<RunManagerState> mapEventToState(
    RunManagerEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
