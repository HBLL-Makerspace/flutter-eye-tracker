part of 'gaze_stream_bloc.dart';

@immutable
abstract class GazeStreamState {}

class GazeStreamInitial extends GazeStreamState {}

class GazeStreamDataState extends GazeStreamState {
  final GazeData gazeData;

  GazeStreamDataState(this.gazeData);
}
