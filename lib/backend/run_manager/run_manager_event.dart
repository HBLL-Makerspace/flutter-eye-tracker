part of 'run_manager_bloc.dart';

@immutable
abstract class RunManagerEvent {}

class RunManagerStartRun extends RunManagerEvent {}

class RunManagerStopRun extends RunManagerEvent {}

class RunManagerAddGazeData extends RunManagerEvent {
  final GazeData gazeData;

  RunManagerAddGazeData(this.gazeData);
}

class RunManagerClearRun extends RunManagerEvent {}
