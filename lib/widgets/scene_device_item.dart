import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/device.dart';

class SceneDeviceItem extends StatefulWidget {
  @override
  _SceneDeviceItemState createState() => _SceneDeviceItemState();
}

class _SceneDeviceItemState extends State<SceneDeviceItem> {
  @override
  Widget build(BuildContext context) {
    final device = Provider.of<Device>(context, listen: false);

    return ListTile(
      title: Text(device.description),
      leading: Icon(Icons.wifi_tethering),
      //interagir com o item
      trailing: Container(
        width: 50,
        child: Row(
          children: [
            Consumer<Device>(
              builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  device.toggleOnOff();
                },
                icon: device.requested_power_state
                    ? Icon(Icons.power)
                    : Icon(Icons.power_off_outlined),
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
