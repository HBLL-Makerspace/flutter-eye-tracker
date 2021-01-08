import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eye_tracker/ui/new_session.dart';
import 'package:page_transition/page_transition.dart';

class StartPage extends StatelessWidget {
  Widget _button(
      BuildContext context, Icon icon, String name, Function onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton.icon(
        padding: const EdgeInsets.all(28.0),
        shape: StadiumBorder(),
        icon: icon,
        onPressed: onPressed,
        label: Expanded(
          child: Center(
            child: Text(
              name,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ButtonTheme(
        minWidth: 500,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 64.0),
                child: Text(
                  "BYU Eye Tracker",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              _button(
                  context,
                  Icon(
                    Icons.play_arrow,
                    color: Colors.green,
                  ),
                  "Start Session",
                  () => Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: NewSession()))),
              _button(
                  context,
                  Icon(
                    Icons.delete,
                    color: Colors.grey,
                  ),
                  "Temporary Session",
                  () => {}),
              _button(
                  context,
                  Icon(
                    Icons.launch,
                    color: Colors.blue,
                  ),
                  "Open Session",
                  () => {}),
            ],
          ),
        ),
      ),
    ));
  }
}
