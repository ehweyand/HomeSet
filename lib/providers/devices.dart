import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/scene_device.dart';
import '../constants.dart';
import 'device.dart';

class Devices with ChangeNotifier {
  List<Device> _items = [];

  List<Device> get items {
    return [..._items];
  }

  List<Device> _sceneRelatedDevices = [];

  List<Device> get sceneRelatedDevices {
    return [..._sceneRelatedDevices];
  }

  //Busca os devices da respectiva cena
  Future<void> fetchAndSetSceneDevices(String sceneId) async {
    // Puxa todos os devices
    fetchAndSetDevices();

    // busco na N:N
    var url = Uri.https(firebaseUrl, '/sceneDevices/$sceneId.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // final List<SceneDevice> loadedSceneDevices = [];
      final List<String> catchedIds = [];

      // Essa List quero retornar com os dados do device vinculado cena
      final List<Device> loadedDevices = [];

      extractedData.forEach((sceneDeviceId, sceneDeviceData) {
        catchedIds.add(sceneDeviceData['deviceId']);
      });

      //Carregando os devices vinculados a cena
      // Apoio
      // extractedData.forEach((sceneDeviceId, sceneDeviceData) {
      //   loadedSceneDevices.add(new SceneDevice(
      //     id: sceneDeviceId,
      //     deviceId: sceneDeviceData['deviceId'],
      //     deviceDescription: sceneDeviceData['deviceDescription'],
      //     sceneId: sceneId,
      //   ));
      // });

      //-------------------------------------------------------------
      // Aqui preciso filtrar e adicionar na segunda lista apenas os dados dos devices que constam na lista anterior

      // loadedSceneDevices.forEach((element) {
      //   var id = element.deviceId; // -MkA1cAXZuQW5ITG7Hhl
      //   Device device = _items.firstWhere((e) => e.id == id);
      //   loadedDevices.add(device);
      // });

      // TOP!
      _sceneRelatedDevices =
          _items.where((e) => catchedIds.contains(e.id)).toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Device findById(String id) {
    return _items.firstWhere((device) => device.id == id);
  }

  // aqui pega todos os devices.. tentar filtrar pra pegar apenas os que tem registro naquela cena...

  Future<void> fetchAndSetDevices() async {
    var url = Uri.https(firebaseUrl, 'devices.json');
    try {
      final response = await http.get(url);
      //para o dart entender o retorno do firebase
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Device> loadedDevices = [];

      extractedData.forEach((deviceId, deviceData) {
        //key, value
        loadedDevices.add(new Device(
          id: deviceId,
          model: deviceData['model'],
          description: deviceData['description'],
          requested_power_state: deviceData['power'],
        ));
      });
      _items = loadedDevices;
      notifyListeners();
    } catch (error) {
      //adicionar tratamento do error - aula 248
      throw (error);
    }
  }

  //async sempre retorna um future - permite omitir o then e o catch
  Future<void> addDevice(Device device) async {
    //exemplo devices_log/-MkA1cAXZuQW5ITG7Hhl/power, valor
    var url = Uri.https(firebaseUrl, 'devices.json');
    try {
      // Poderia adicionar o header como metadata necessários para API
      final response = await http.post(
        url,
        body: json.encode({
          'model': device.model,
          'description': device.description,
          'requested_power_state': device.requested_power_state,
        }),
      );
      print(response.body);
      //Só executa após o await terminar - bloco then invisível
      final newDevice = Device(
        model: device.model,
        description: device.description,
        requested_power_state: false,
        //id gerada no firebase
        id: json.decode(response.body)['name'],
      );
      _items.add(newDevice);
      // _items.insert(0, newDevice); //adiciona no começo da lista
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateDevice(String id, Device newDevice) async {
    final deviceIndex = _items.indexWhere((device) => device.id == id);
    //verifica se encontrou algo
    if (deviceIndex >= 0) {
      final url = Uri.https(firebaseUrl, '/devices/$id.json');
      //pode colocar um tratamento de erro também...
      await http.patch(url,
          body: json.encode({
            'model': newDevice.model,
            'description': newDevice.description,
            //o atributo de power não será alterado agora...
          }));

      _items[deviceIndex] = newDevice;
      notifyListeners();
    } else {
      print('Erro: Dispositivo não encontrado para atualizar.');
    }
  }

  Future<void> deleteDevice(String id) async {
    final url = Uri.https(firebaseUrl, '/devices/$id.json');
    // Optimistic update //
    // //////////////// //
    final existingDeviceIndex = _items.indexWhere((device) => device.id == id);
    var existingDevice = _items[existingDeviceIndex];
    _items.removeAt(existingDeviceIndex);
    notifyListeners();

    final response = await http.delete(url);
    // Executa abaixo após receber a response
    // Verifica pelo statuscode, se deu erro
    if (response.statusCode >= 400) {
      // Rollback
      _items.insert(existingDeviceIndex, existingDevice);
      notifyListeners();
      throw HttpException('Não foi possível deletar o dispositivo.');
    }

    existingDevice = null;
  }
}
