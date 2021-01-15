part of 'run_manager_bloc.dart';

@immutable
abstract class RunManagerState {}

class RunManagerInitial extends RunManagerState {}

class RunManagerRunning extends RunManagerState {
  final RunBuilder runBuilder;

  RunManagerRunning(this.runBuilder);
}

class RunManagerRunStopped extends RunManagerState {
  final RunBuilder runBuilder;

  RunManagerRunStopped(this.runBuilder);
}

class RunManagerNoRun extends RunManagerState {}
