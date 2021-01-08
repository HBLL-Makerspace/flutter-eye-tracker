import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Center(
        child: Text(
      "00:00:00",
      style: Theme.of(context).textTheme.headline2,
    ));
  }

  Widget _startButton() {
    return Tooltip(
      message: _isRunning ? "Stop Run" : "New Run",
      child: MaterialButton(
        onPressed: () {
          if (_isRunning)
            _animationController.reverse();
          else
            _animationController.forward();
          setState(() {
            _isRunning = !_isRunning;
          });
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
    return Container(
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
    );
  }
}
