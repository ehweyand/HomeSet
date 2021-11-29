import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scenes.dart';
import '../providers/devices.dart';
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
    // Setup inicial

    // final devicesData = Provider.of<Devices>(context);
    // devicesData.fetchAndSetSceneDevices(sceneId);
    // final devices = devicesData.sceneRelatedDevices;

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
          Expanded(
            child: FutureBuilder(
              future: Provider.of<Devices>(context, listen: false)
                  .fetchAndSetSceneDevices(sceneId),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    // Implementação de lógica de erro.
                    return Center(
                      child: Text(
                          'Nenhum dispositivo encontrado vinculado à esta cena.'),
                    );
                  } else {
                    // Encontrou algo
                    print(dataSnapshot.data);
                    return Consumer<Devices>(
                      builder: (ctx, devicesData, child) => ListView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: devicesData.sceneRelatedDevices.length,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value: devicesData.sceneRelatedDevices[i],
                          child: SceneDeviceItem(),
                        ),
                      ),
                    );
                  }
                }
              },
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
