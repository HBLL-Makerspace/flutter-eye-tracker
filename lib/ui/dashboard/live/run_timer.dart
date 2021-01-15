import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eye_tracker/backend/run_manager/run_manager_bloc.dart';
import 'package:flutter_eye_tracker/backend/run_timer/run_timer_bloc.dart';

class RunTimer extends StatefulWidget {
  @override
  _RunTimerState createState() => _RunTimerState();
}

class _RunTimerState extends State<RunTimer>
    with SingleTickerProviderStateMixin<RunTimer> {
  AnimationController _animationController;

  bool _isRunning = false;

  @override
  initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  Widget _timer(BuildContext context) {
    String _printDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes);
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      String twoDigitMilliseconds =
          twoDigits(duration.inMilliseconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
    }

    return Center(child: BlocBuilder<RunTimerBloc, RunTimerState>(
      builder: (context, state) {
        String sDuration =
            "${state.elapsed.inMinutes}:${(state.elapsed.inSeconds.remainder(60))}.${(state.elapsed.inMilliseconds.remainder(60))}";
        return Text(
          _printDuration(state.elapsed),
          style: Theme.of(context).textTheme.headline2,
        );
      },
    ));
  }

  Widget _startButton() {
    return Tooltip(
      message: _isRunning ? "Stop Run" : "New Run",
      child: MaterialButton(
        onPressed: () {
          if (_isRunning) {
            // _animationController.reverse();
            context.read<RunTimerBloc>().add(RunTimerEventStop());
            context.read<RunManagerBloc>().add(RunManagerStopRun());
          } else {
            // _animationController.forward();
            context.read<RunTimerBloc>().add(RunTimerEventStart());
            context.read<RunManagerBloc>().add(RunManagerStartRun());
          }
        },
        color: _isRunning ? Colors.red[300] : Colors.green[300],
        textColor: Colors.white,
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RunTimerBloc, RunTimerState>(
      listener: (context, state) {
        if (state is RunTimerRunning) {
          this._animationController.forward();
          setState(() {
            _isRunning = true;
          });
        } else {
          this._animationController.reverse();
          setState(() {
            _isRunning = false;
          });
        }
      },
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: _timer(context),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _startButton(),
            )
          ],
        ),
      ),
    );
  }
}
