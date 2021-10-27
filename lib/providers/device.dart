import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Device with ChangeNotifier {
  final String id;
  final String model;
  final String description;
  bool requested_power_state;

  Device({
    @required this.id,
    @required this.model,
    @required this.description,
    //valor default é false
    this.requested_power_state = false,
  });

  /// Toggles On and Off the requested_power_state of the device. Also, notifies all listeners about the changes.
  void _setOnOff(bool newValue) {
    requested_power_state = newValue;
    notifyListeners();
  }

  /// Communicates with firebase's database to change the actual requested_power_state status of the device.
  /// Work in progress...
  Future<void> toggleOnOff(String token, String userId) async {
    final oldStatus = requested_power_state;
    requested_power_state = !requested_power_state;
    notifyListeners();
    final url = Uri.https('flutter-update.firebaseio.com',
        '/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          requested_power_state,
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
