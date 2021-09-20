import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/devices.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_device_item.dart';

import '../screens/edit_device_screen.dart';

class UserDevicesScreen extends StatelessWidget {
  static const routeName = '/user-devices';

  Future<void> _refreshDevices(BuildContext context) async {
    await Provider.of<Devices>(context, listen: false).fetchAndSetDevices();
    //apenas quando terminar retorna o Future
  }

  @override
  Widget build(BuildContext context) {
    final devicesData = Provider.of<Devices>(context);
    return Scaffold(
      appBar: AppBar(
        //const para o flutter não rebuildar
        title: const Text('Seus dispositivos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditDeviceScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      //poderia usar Consumer<> do provider para rebuildar apenas a lista
      body: RefreshIndicator(
        onRefresh: () => _refreshDevices(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          //melhoria de performance para listas maiores
          child: ListView.builder(
            itemCount: devicesData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserDeviceItem(
                  devicesData.items[i].id,
                  devicesData.items[i].model,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
