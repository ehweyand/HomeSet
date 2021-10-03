import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';

import '../screens/edit_device_category_screen.dart';

class GeneralCategoryDeviceItem extends StatelessWidget {
  // To show on screen
  final String id;
  final String description;

  GeneralCategoryDeviceItem(this.id, this.description);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(description),
      leading: Icon(Icons.settings_remote_rounded),
      //interagir com o item
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                // Sending the correct id to be edited
                Navigator.of(context).pushNamed(
                    EditDeviceCategoryScreen.routeName,
                    arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Categories>(context, listen: false)
                      .deleteCategory(id);
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
