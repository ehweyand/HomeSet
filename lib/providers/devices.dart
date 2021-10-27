import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../constants.dart';
import 'device.dart';

class Devices with ChangeNotifier {
  List<Device> _items = [];

  //Para vincular os devices cadastrados ao usuário - posteriormente
  /*
  final String authToken;
  final String userId;

  Devices(this.authToken, this.userId, this._items);*/

  List<Device> get items {
    return [..._items];
  }

  /* HTTP Request para persistir no firebase */

  Device findById(String id) {
    return _items.firstWhere((device) => device.id == id);
  }

  Future<void> fetchAndSetDevices() async {
    //pode testar também Uri.parse('<url>')
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
