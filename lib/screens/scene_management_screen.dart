import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scenes.dart';

import 'device_selection_screen.dart';

class SceneManagementScreen extends StatelessWidget {
  static const routeName = '/scene-management';

  @override
  Widget build(BuildContext context) {
    // Recupera as informações necessárias
    final sceneId =
        ModalRoute.of(context).settings.arguments as String; // é o id da cena
    final loadedScene = Provider.of<Scenes>(
      context,
      listen: false,
    ).findById(sceneId);

    // A tela em si
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedScene.nickname),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                'https://cdn.pixabay.com/photo/2016/06/01/17/43/house-1429409_1280.png',
                fit: BoxFit.cover,
              ),
            ),
            // Espaçamento
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedScene.nickname}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedScene.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Text('GRID DE DISPOSITIVOS'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context)
              .pushNamed(DeviceSelectionScreen.routeName, arguments: sceneId);
        },
      ),
    );
  }
}
