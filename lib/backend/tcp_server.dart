import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_eye_tracker/model/client.dart';
import 'package:flutter_eye_tracker/model/json_message.dart';
import 'package:flutter_eye_tracker/model/tcp_message.dart';
import 'package:uuid/uuid.dart';

const SERVER_ADDRESS = "localhost";
const SERVER_PORT = 8052;
final int EOM = 0;

class TCPServer {
  static Client _unityEyeClient;
  static ServerSocket _serverSocket;
  static Map<Type, StreamController> dataStream = {};
  static Map<Type, dynamic Function(Map<String, dynamic>)> _converters = {
    GazeData: (data) => GazeData.fromJson(data),
    ClientConnected: (data) => ClientConnected.fromJson(data),
  };
  static bool _running = false;
  // static Uint8List _data = Uint8List(1024);
  static List<int> _data = [];

  static void _handleIncomingData(Uint8List data) {
    // print("Incoming Data: " + String.fromCharCodes(data));
    // print("Looking for $EOM in ${data.toList()}");
    int _index = data.indexOf(EOM); // Look for end of message.
    // print("Found index at: $_index");

    // If the end of message is in the data then proccess,
    // else just copy over.
    if (_index == -1) {
      _data.addAll(data);
      return;
    }

    Uint8List _msg = data.sublist(0, _index);
    Uint8List _rest = data.sublist(_index + 1);

    _data.addAll(_msg);
    _handleIncomingMessage();

    if (_rest.isNotEmpty) _handleIncomingData(_rest);
  }

  static void _handleIncomingMessage() {
    // print("Converting: ${_data.toList()}");
    String jsonString = String.fromCharCodes(_data).trim();
    // print("Got message: " + jsonString + " end");
    TCPMessage jsonMessage = TCPMessage.fromJson(jsonDecode(jsonString));
    dataStream.forEach((key, value) {
      if (key.toString() == jsonMessage.type && _converters.containsKey(key)) {
        // print("Got message for: $key");
        print(_converters[key](jsonDecode(jsonMessage.message)).toString());
        value.add(_converters[key](jsonDecode(jsonMessage.message)));
      }
    });
    _data = [];
  }

  static Stream<T> on<T extends JsonMessage>() {
    if (!dataStream.containsKey(T))
      dataStream[T] = StreamController<T>.broadcast();
    return dataStream[T].stream;
  }

  static void _onClientConnect(Socket socket) {
    print("Client connected");
    _unityEyeClient = Client(uid: Uuid().v4(), socket: socket);
    _unityEyeClient.socket.listen((data) {
      _handleIncomingData(data);
    });
  }

  static void start(
      {String host = SERVER_ADDRESS, int port = SERVER_PORT}) async {
    if (!_running) {
      print("Starting the tcp server.");
      _serverSocket = await ServerSocket.bind(SERVER_ADDRESS, SERVER_PORT);
      _serverSocket.listen(_onClientConnect);
      _running = true;
      _data = [];
    } else {
      stop();
      // Possible bug here, this only works for hot reload, should be removed.
      start();
    }
  }

  static void stop() {
    dataStream.forEach((key, value) => {value.close()});
    dataStream.clear();
    _data = [];
    _serverSocket.close();
    _running = false;
  }

  static void sendMessage(JsonMessage jsonMessage) {
    Map<String, dynamic> msg = {
      "type": jsonMessage.runtimeType.toString(),
      "message": jsonMessage.toJsonString()
    };
    _unityEyeClient.socket.write(jsonEncode(msg));
  }
}
