part of 'session_bloc.dart';

@immutable
abstract class SessionState {}

class SessionInitial extends SessionState {}

class SessionStateLoading extends SessionState {}

class SessionStateDone extends SessionState {
  final Session session;

  SessionStateDone(this.session);
}

class SessionStateFailed extends SessionState {}
