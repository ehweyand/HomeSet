import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Device with ChangeNotifier {
  final String id;
  final String model;
  final String description;
  bool power;

  Device({
    @required this.id,
    @required this.model,
    @required this.description,
    //valor default é false
    this.power = false,
  });

  /// Toggles On and Off the power of the device. Also, notifies all listeners about the changes.
  void _setOnOff(bool newValue) {
    power = newValue;
    notifyListeners();
  }

  /// Communicates with firebase's database to change the actual power status of the device.
  /// Work in progress...
  Future<void> toggleOnOff(String token, String userId) async {
    final oldStatus = power;
    power = !power;
    notifyListeners();
    final url = Uri.https('flutter-update.firebaseio.com',
        '/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          power,
        ),
      );
      if (response.statusCode >= 400) {
        _setOnOff(oldStatus);
      }
    } catch (error) {
      _setOnOff(oldStatus);
    }
  }
}
