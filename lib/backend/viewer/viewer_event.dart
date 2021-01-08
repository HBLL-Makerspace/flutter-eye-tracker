part of 'viewer_bloc.dart';

@immutable
abstract class ViewerEvent {}

class ViewerEventLaunch extends ViewerEvent {
  final Session session;

  ViewerEventLaunch(this.session);
}

class ViewerEventClose extends ViewerEvent {}

class ViewerEventConnected extends ViewerEvent {}
