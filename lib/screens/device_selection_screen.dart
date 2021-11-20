import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/devices.dart';
import '../providers/scene_devices.dart';

class DeviceSelectionScreen extends StatelessWidget {
  static const routeName = '/device-selection';

  Future<void> _refreshDevices(BuildContext context) async {
    await Provider.of<Devices>(context, listen: false).fetchAndSetDevices();
    // Apenas quando terminar retorna o Future
  }

  @override
  Widget build(BuildContext context) {
    // Recupera o id da cena vindo da rota
    final sceneId = ModalRoute.of(context).settings.arguments as String;
    print(sceneId);
    // Para mostrar um snackbar
    final scaffold = ScaffoldMessenger.of(context);
    // Busca todos os devices
    final devicesData = Provider.of<Devices>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar à cena'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshDevices(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Scrollbar(
            child: ListView.builder(
              itemCount: devicesData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  // //ListTile aqui
                  ListTile(
                    title: Text(devicesData.items[i].model),
                    leading: Icon(Icons.add_to_queue),
                    trailing: IconButton(
                      onPressed: () {
                        // Enviar para o servidor o registro com o ID da cena...
                        Provider.of<SceneDevices>(context, listen: false)
                            .linkToScene(sceneId, devicesData.items[i]);
                      },
                      icon: Icon(Icons.add),
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
