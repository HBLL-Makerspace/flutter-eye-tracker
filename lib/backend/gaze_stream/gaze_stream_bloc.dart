import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:unity_eye_tracker/model/json_message.dart';

part 'gaze_stream_event.dart';
part 'gaze_stream_state.dart';

class GazeStreamBloc extends Bloc<GazeStreamEvent, GazeStreamState> {
  GazeStreamBloc() : super(GazeStreamInitial());

  @override
  Stream<GazeStreamState> mapEventToState(
    GazeStreamEvent event,
  ) async* {
    yield GazeStreamDataState((event as GazeStreamEventData).gazeData);
  }
}
