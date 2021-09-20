import 'package:flutter/material.dart';

import '../screens/user_devices_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Olá usuário!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.plagiarism_outlined),
            title: Text('Cenas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar Dispositivos'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserDevicesScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
