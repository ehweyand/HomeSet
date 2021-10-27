import 'package:flutter/material.dart';

class DeviceLog {
  // ID vai ter relação direta com o ID do device (exatamente o id do device)
  final String id;
  final bool power;
  final int last_update;

  DeviceLog({@required this.id, @required this.power, this.last_update});
}
