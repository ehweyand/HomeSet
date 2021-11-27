import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device.dart';

class SceneDeviceItem extends StatelessWidget {
  // final String id;
  // final String description;
  // final String deviceId;

  // // Positional arguments
  // SceneDeviceItem(this.id, this.description, this.deviceId);

  final Device sceneDevice;

  SceneDeviceItem(this.sceneDevice);

  @override
  Widget build(BuildContext context) {
    // final scaffold = ScaffoldMessenger.of(context);
    print(sceneDevice.requested_power_state);

    return ListTile(
      title: Text(sceneDevice.description),
      leading: Icon(Icons.wifi_tethering),
      //interagir com o item
      trailing: Container(
        width: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                sceneDevice.toggleOnOff();
              },
              icon: sceneDevice.requested_power_state
                  ? Icon(Icons.power)
                  : Icon(Icons.power_off_outlined),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
