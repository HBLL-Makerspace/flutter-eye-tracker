part of 'viewer_bloc.dart';

@immutable
abstract class ViewerState {}

class ViewerInitial extends ViewerState {}

class ViewerStateLaunching extends ViewerState {}

class ViewerStateConnected extends ViewerState {}

class ViewerStateClosed extends ViewerState {}
