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

class TCPServer {
  static Client _unityEyeClient;
  static ServerSocket _serverSocket;
  static Map<Type, StreamController> dataStream = {};
  static Map<Type, dynamic Function(Map<String, dynamic>)> _converters = {
    GazeData: (data) => GazeData.fromJson(data)
  };
  static bool _running = false;

  static void _handleIncominMessage(Uint8List data) {
    // print("Got message: " + String.fromCharCodes(data));
    TCPMessage jsonMessage =
        TCPMessage.fromJson(jsonDecode(String.fromCharCodes(data)));
    dataStream.forEach((key, value) {
      if (key.toString() == jsonMessage.type && _converters.containsKey(key)) {
        // print("Got message for: $key");
        // print(_converters[key](jsonDecode(jsonMessage.message)).toString());
        value.add(_converters[key](jsonDecode(jsonMessage.message)));
      }
    });
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
      _handleIncominMessage(data);
    });
  }

  static void start(
      {String host = SERVER_ADDRESS, int port = SERVER_PORT}) async {
    if (!_running) {
      print("Starting the tcp server.");
      _serverSocket = await ServerSocket.bind(SERVER_ADDRESS, SERVER_PORT);
      _serverSocket.listen(_onClientConnect);
      _running = true;
    } else {
      stop();
      // Possible bug here, this only works for hot reload, should be removed.
      start();
    }
  }

  static void stop() {
    dataStream.forEach((key, value) => {value.close()});
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
