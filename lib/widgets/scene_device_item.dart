import 'package:flutter/material.dart';

//Único ítem da lista
class SceneDeviceItem extends StatelessWidget {
  final String id;
  final String description;

  //positional arguments
  SceneDeviceItem(this.id, this.description);

  @override
  Widget build(BuildContext context) {
    // final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(description),
      leading: Icon(Icons.wifi_tethering),
      //interagir com o item
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                // maybe do something, or not...
              },
              icon: Icon(Icons.power),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
