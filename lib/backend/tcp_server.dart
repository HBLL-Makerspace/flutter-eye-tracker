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
    GazeData: (data) => GazeData.fromJson(data),
    ClientConnected: (data) => ClientConnected.fromJson(data),
  };
  static bool _running = false;
  static Uint8List _data = Uint8List(1024);
  static int _dataIndex = 0;

  static void _handleIncomingData(Uint8List data) {
    int index = 0;
    int char = 0;
    while (String.fromCharCode(char = data[index++]) != "\n") {
      _data[_dataIndex++] = char;
    }

    // If there is enough for a message then process the message.
    if (String.fromCharCode(char) == "\n") {
      // print("Found message");
      _handleIncominMessage();
    }

    // Continue until all the data in the list is handled.
    // If there is no data left wait for some more to come.
    if (index != data.length) {
      _handleIncomingData(data.sublist(index));
    }
  }

  static void _handleIncominMessage() {
    String jsonString =
        String.fromCharCodes(_data.sublist(0, _dataIndex)).trim();
    // print("Got message: " + jsonString);
    TCPMessage jsonMessage = TCPMessage.fromJson(jsonDecode(jsonString));
    dataStream.forEach((key, value) {
      if (key.toString() == jsonMessage.type && _converters.containsKey(key)) {
        // print("Got message for: $key");
        print(_converters[key](jsonDecode(jsonMessage.message)).toString());
        value.add(_converters[key](jsonDecode(jsonMessage.message)));
      }
    });
    _dataIndex = 0; // Reset list
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
    } else {
      stop();
      // Possible bug here, this only works for hot reload, should be removed.
      start();
    }
  }

  static void stop() {
    dataStream.forEach((key, value) => {value.close()});
    dataStream.clear();
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
