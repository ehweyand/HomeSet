import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/devices.dart';

import '../screens/edit_device_screen.dart';

//Único ítem da lista
class UserDeviceItem extends StatelessWidget {
  //informações do device pra mostrar no item
  final String id;
  final String model;

  // podia usar uma callback function que é passada via param no construtor e chamada aqui
  // ai não precisaria chamar o provider aqui também, por exemplo.
  // final Function deleteHandler;

  //positional arguments
  UserDeviceItem(this.id, this.model);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(model),
      leading: Icon(Icons.settings_remote_rounded),
      //interagir com o item
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                //passa como parâmetro o id que vai ser editado.
                Navigator.of(context)
                    .pushNamed(EditDeviceScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Devices>(context, listen: false)
                      .deleteDevice(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content:
                        Text('Falha na exclusão.', textAlign: TextAlign.center),
                  ));
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
