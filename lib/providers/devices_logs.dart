import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/device_log.dart';

import '../constants.dart';

class DevicesLogs with ChangeNotifier {
  List<DeviceLog> _items = [];

  List<DeviceLog> get items {
    return [..._items];
  }

  DeviceLog findById(String id) {
    return _items.firstWhere((device_log) => device_log.id == id);
  }

  Future<void> fetchAndSetDevicesLog() async {
    var url = Uri.https(firebaseUrl, 'devices_log.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<DeviceLog> loadedDevicesLog = [];

      extractedData.forEach((deviceLogId, deviceLogData) {
        loadedDevicesLog.add(new DeviceLog(
          id: deviceLogId,
          power: deviceLogData['power'],
          last_update: deviceLogData['last_update'],
        ));
      });

      _items = loadedDevicesLog;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
