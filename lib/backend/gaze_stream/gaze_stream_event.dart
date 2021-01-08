part of 'gaze_stream_bloc.dart';

@immutable
abstract class GazeStreamEvent {}

class GazeStreamEventData extends GazeStreamEvent {
  final GazeData gazeData;

  GazeStreamEventData(this.gazeData);
}
