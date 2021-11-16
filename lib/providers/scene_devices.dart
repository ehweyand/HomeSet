import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/scene_device.dart';
import '../models/http_exception.dart';

class SceneDevices with ChangeNotifier {
  // armazenamento local
  List<SceneDevice> _items = [];

  // getter
  List<SceneDevice> get items {
    return [..._items];
  }

  Future<void> linkToScene(String sceneId, String deviceId) async {
    final url = Uri.https(firebaseUrl, '/sceneDevices/$sceneId.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'deviceId': deviceId,
        }),
      );
      //Só executa após o await terminar - bloco then invisível
      final newSceneDevice = SceneDevice(
        sceneId: sceneId,
        deviceId: deviceId,
        //id gerada no firebase
        id: json.decode(response.body)['name'],
      );
      _items.add(newSceneDevice);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
