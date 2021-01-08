import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_eye_tracker/model/session.dart';
import 'package:flutter_eye_tracker/ui/dashboard/dashboard.dart';
import 'package:flutter_eye_tracker/ui/provider.dart';

class NewSession extends StatefulWidget {
  @override
  _NewSessionState createState() => _NewSessionState();
}

class _NewSessionState extends State<NewSession> {
  int _index = 0;
  PageController _controller;
  File _pictureFile;

  final _pageDuration = Duration(milliseconds: 300);
  final _pageCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _controller.addListener(() {
      setState(() {
        _index = _controller.page.toInt();
      });
    });
  }

  Widget _topBar(Step currentStep, int numSteps) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              children: [
                Tooltip(
                  message: "Cancel",
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                    onPressed: () => {Navigator.pop(context)},
                  ),
                ),
                currentStep.title,
                Text(
                  " (Step ${_index + 1} of $numSteps)",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashboard(BuildContext context) {
    return BlocProviders(
      child: Dashboard(
        session: Session(picture: _pictureFile),
      ),
    );
  }

  Widget _bottomBar(int numSteps) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              FlatButton(
                onPressed: () => {
                  if (_index != 0)
                    _controller.animateToPage(_index - 1,
                        duration: _pageDuration, curve: _pageCurve)
                  else
                    Navigator.pop(context)
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_index != 0 ? "Previous" : "Cancel"),
                ),
                shape: StadiumBorder(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LinearPercentIndicator(
                    lineHeight: 8.0,
                    percent: _index / (numSteps - 1),
                    animateFromLastPercent: true,
                    animation: true,
                    animationDuration: 300,
                    curve: Curves.easeInOut,
                    progressColor: _index / (numSteps - 1) == 1
                        ? Colors.green
                        : Colors.blue,
                  ),
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () => {
                  if (_index + 1 != numSteps)
                    _controller.animateToPage(_index + 1,
                        duration: _pageDuration, curve: _pageCurve)
                  else
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: _dashboard(context),
                            type: PageTransitionType.fade))
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                shape: StadiumBorder(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getPicture() {
    final file = OpenFilePicker()
      ..filterSpecification = {
        // 'Word Document (*.doc)': '*.doc',
        // 'Web Page (*.htm; *.html)': '*.htm;*.html',
        // 'Text Document (*.txt)': '*.txt',
        'PNG': '*.png;*.PNG',
        "JPG": ''
      }
      ..defaultFilterIndex = 0
      ..defaultExtension = 'doc'
      ..title = 'Select a document';

    final result = file.getFile();
    if (result != null) {
      setState(() {
        _pictureFile = result;
      });
    }
  }

  Widget _pictureStep() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                "Picture",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: _pictureFile == null
                  ? DottedBorder(
                      borderType: BorderType.RRect,
                      dashPattern: [8, 8],
                      radius: Radius.circular(8.0),
                      color: Colors.grey,
                      strokeWidth: 1,
                      child: Material(
                        child: SizedBox(
                            width: 250,
                            height: 250,
                            child: IconButton(
                              tooltip: "Choose picture",
                              icon: Icon(
                                Icons.publish,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _getPicture();
                              },
                            )),
                      ),
                    )
                  : SizedBox(
                      width: 250,
                      height: 250,
                      child: Material(
                        child: InkWell(
                            onTap: () {
                              _getPicture();
                            },
                            child: Image.file(_pictureFile)),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _nameStep() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                "Session Name",
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    labelText: "Input a name for your session",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100))),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Step> _steps = [
      Step(title: Text("Name"), content: _nameStep()),
      Step(title: Text("Picture"), content: _pictureStep()),
    ];
    return Scaffold(
      body: Material(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _topBar(_steps[_index], _steps.length),
              Expanded(
                  child: PageView(
                controller: _controller,
                children:
                    _steps.map((e) => Container(child: e.content)).toList(),
              )),
              _bottomBar(_steps.length)
            ],
          ),
        ),
      ),
    );
  }
}
