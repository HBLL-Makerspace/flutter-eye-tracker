import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eye_tracker/backend/tcp_server.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:flutter_eye_tracker/ui/theme.dart';

class Controls extends StatefulWidget {
  @override
  _ControlsState createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  Widget _slider(
      BuildContext context, double value, ValueChanged<double> onChanged) {
    return Slider(
      value: value,
      label: '${value.toStringAsFixed(1)}',
      onChanged: onChanged,
      divisions: 100,
      min: -5,
      max: 5,
    );
  }

  void _updatePicture() {
    TCPServer.sendMessage(PictureOffset(x, y, z));
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: Theming.background_blue_grey,
        inactiveTrackColor: Theming.background_blue_grey,
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        thumbColor: Theming.royal,
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Theming.royal,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _slider(context, z, (v) {
            setState(() {
              z = v;
            });
            _updatePicture();
          }),
          _slider(context, y, (v) {
            setState(() {
              y = v;
            });
            _updatePicture();
          })
        ],
      ),
    );
  }
}
