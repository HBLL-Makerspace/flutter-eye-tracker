import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eye_tracker/backend/gaze_stream/gaze_stream_bloc.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:flutter_eye_tracker/model/session.dart';

const IMAGE_SIZE = 500;

class LiveGazeData extends StatefulWidget {
  final Session session;

  const LiveGazeData({Key key, this.session}) : super(key: key);

  @override
  _LiveGazeDataState createState() => _LiveGazeDataState();
}

class _LiveGazeDataState extends State<LiveGazeData> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _dataFromState(GazeStreamState state) {
      if (state.runtimeType == GazeStreamDataState) {
        var typed = state as GazeStreamDataState;
        return [Text("X: ${typed.gazeData.x}"), Text("Y: ${typed.gazeData.y}")];
      } else {
        return [Container()];
      }
    }

    Widget _drawLiveView(GazeStreamState state) {
      return AspectRatio(
        aspectRatio: widget.session.image.width.toDouble() /
            widget.session.image.height.toDouble(),
        child: CustomPaint(
          painter: LiveGazePointCustomPainter(
              gaze: (state is GazeStreamDataState)
                  ? (state).gazeData
                  : GazeData(x: 0, y: 0),
              image: widget.session.image),
        ),
      );
    }

    return BlocBuilder<GazeStreamBloc, GazeStreamState>(
      builder: (context, state) {
        return Container(
          child: _drawLiveView(state),
        );
      },
    );
  }
}

class LiveGazePointCustomPainter extends CustomPainter {
  final GazeData gaze;
  final ui.Image image;

  LiveGazePointCustomPainter({this.gaze, this.image});

  void paintImage(
      ui.Image image, Rect outputRect, Canvas canvas, Paint paint, BoxFit fit) {
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(fit, imageSize, outputRect.size);
    final Rect inputSubrect =
        Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect =
        Alignment.center.inscribe(sizes.destination, outputRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      paintImage(
          image,
          Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
          canvas,
          Paint(),
          BoxFit.fill);
      // canvas.drawImage(image, Offset.zero, Paint());
    }

    if (gaze != null) {
      Paint pointPainter = Paint()
        ..color = Colors.purpleAccent[200]
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(
          ui.PointMode.points,
          [Offset(gaze.x * size.width, size.height - (gaze.y * size.height))],
          pointPainter);
    }
  }

  @override
  bool shouldRepaint(covariant LiveGazePointCustomPainter oldDelegate) {
    // ignore: unnecessary_statements
    return gaze != oldDelegate.gaze || image != oldDelegate.image;
  }
}
