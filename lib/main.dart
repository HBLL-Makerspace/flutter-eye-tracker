import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eye_tracker/backend/tcp_server/tcpserver_bloc.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:flutter_eye_tracker/ui/start_page.dart';
import 'package:flutter_eye_tracker/ui/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BYU Eye Tracker',
      theme: ThemeData(fontFamily: 'Roboto', primaryColor: Theming.royal),
      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool point = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TCPServerBloc, TCPServerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              children: [
                RaisedButton(
                  onPressed: () async {
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
                      context.read<TCPServerBloc>().add(
                          TCPServerEventSendMessage(
                              SetPicture(filepath: result.path)));
                    }
                  },
                  child: Text("File picker"),
                ),
                RaisedButton(
                  onPressed: () async {
                    final file = OpenFilePicker()
                      ..filterSpecification = {
                        // 'Word Document (*.doc)': '*.doc',
                        // 'Web Page (*.htm; *.html)': '*.htm;*.html',
                        // 'Text Document (*.txt)': '*.txt',
                        "All Files": '*'
                      }
                      ..defaultFilterIndex = 0
                      ..defaultExtension = 'png'
                      ..title = 'Select a document';

                    final result = file.getFile();
                    if (result != null) {
                      context.read<TCPServerBloc>().add(
                          TCPServerEventSendMessage(
                              SkyBoxUpdate(filepath: result.path)));
                    }
                  },
                  child: Text("Select Skybox"),
                ),
                RaisedButton(
                  onPressed: () async {
                    context.read<TCPServerBloc>().add(
                        TCPServerEventSendMessage(ShowPoint(point = !point)));
                  },
                  child: Text("Show Point"),
                ),
                RaisedButton(
                  onPressed: () async {
                    context
                        .read<TCPServerBloc>()
                        .add(TCPServerEventSendMessage(GenerateHeatMap()));
                  },
                  child: Text("Generate Heat Map"),
                ),
                RaisedButton(
                  onPressed: () => {
                    context.read<TCPServerBloc>().add(TCPServerEventStart())
                  },
                  child: Text("Start"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
