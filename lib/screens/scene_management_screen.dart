import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scenes.dart';
import '../providers/scene_devices.dart';

import '../widgets/scene_device_item.dart';

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

    final sceneDevicesData = Provider.of<SceneDevices>(context);

    // Puxa os dados do firebase
    sceneDevicesData.fetchAndSetSceneDevices(sceneId);
    // tem que ver uma forma de filtrar apenas por cena

    // A tela em si
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedScene.nickname),
      ),
      body: Column(
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
            '${loadedScene.nickname}',
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
          SizedBox(
            height: 10,
          ),
          //List of devices related to scene
          Expanded(
            child: ListView.builder(
              itemCount: sceneDevicesData.items.length,
              //Cria a lista em colunas
              itemBuilder: (_, i) => Column(
                children: [
                  SceneDeviceItem(
                    sceneDevicesData.items[i].id,
                    sceneDevicesData.items[i].deviceDescription,
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ],
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
