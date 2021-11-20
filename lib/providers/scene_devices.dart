import 'package:HomeSet/providers/device.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/scene_device.dart';
import '../models/http_exception.dart';

class SceneDevices with ChangeNotifier {
  static const persistenceArrayName = "sceneDevices";

  // armazenamento local
  List<SceneDevice> _items = [];

  // getter
  List<SceneDevice> get items {
    return [..._items];
  }

  //Busca os devices da respectiva
  Future<void> fetchAndSetSceneDevices(String sceneId) async {
    var url = Uri.https(firebaseUrl, '/sceneDevices/$sceneId.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<SceneDevice> loadedSceneDevice = [];

      // sceneDeviceId --> o id gerado para ligação do device com a cena
      extractedData.forEach((sceneDeviceId, sceneDeviceData) {
        loadedSceneDevice.add(new SceneDevice(
          id: sceneDeviceId,
          deviceId: sceneDeviceData['deviceId'],
          deviceDescription: sceneDeviceData['deviceDescription'],
          sceneId: sceneId,
        ));
      });
      _items = loadedSceneDevice;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> linkToScene(String sceneId, Device device) async {
    final url = Uri.https(firebaseUrl, '/$persistenceArrayName/$sceneId.json');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'deviceId': device.id,
          'deviceDescription': device.description,
        }),
      );
      //Só executa após o await terminar - bloco then invisível
      final newSceneDevice = SceneDevice(
        sceneId: sceneId,
        deviceId: device.id,
        deviceDescription: device.description,
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
