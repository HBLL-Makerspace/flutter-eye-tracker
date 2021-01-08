import 'dart:async';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_eye_tracker/model/session.dart';
import 'package:image/image.dart' as im;

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(SessionInitial());

  @override
  Stream<SessionState> mapEventToState(
    SessionEvent event,
  ) async* {
    switch (event.runtimeType) {
      case SessionEventLoad:
        var typed = event as SessionEventLoad;
        yield SessionStateLoading();
        final data = await typed.session?.picture?.readAsBytes();
        if (data != null) {
          ui.Image tex = await decodeImageFromList(data);
          yield SessionStateDone(typed.session.copyWith(image: tex));
        } else {
          yield SessionStateFailed();
        }
    }
  }
}
