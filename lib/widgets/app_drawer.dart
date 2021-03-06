import 'package:HomeSet/screens/general_devices_categories_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/change_theme_button.dart';

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
          ChangeThemeButtonWidget(),
          Divider(),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Cenas'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar dispositivos'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserDevicesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.architecture),
            title: Text('Categorias disponíveis'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                  GeneralDevicesCategoriesScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
