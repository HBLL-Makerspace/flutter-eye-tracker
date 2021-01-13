part of 'run_manager_bloc.dart';

@immutable
abstract class RunManagerState {}

class RunManagerInitial extends RunManagerState {}

class RunManagerRunning extends RunManagerState {}

class RunManagerNoRun extends RunManagerState {}

class RunInfo {
  final GazeData currentGazeData;
  final GazeData gazeWindow;

  RunInfo({this.currentGazeData, this.gazeWindow});
}
