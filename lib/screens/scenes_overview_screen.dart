import 'package:HomeSet/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';

import '../providers/scenes.dart';
import '../providers/devices.dart';

import './edit_device_screen.dart';
import 'edit_device_category_screen.dart';

class ScenesOverviewScreen extends StatefulWidget {
  @override
  _ScenesOverviewScreenState createState() => _ScenesOverviewScreenState();
}

class _ScenesOverviewScreenState extends State<ScenesOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  //
  // @override
  // void initState() {
  // Provider.of<Scenes>(context, listen: false).fetchAndSetScenes();
  // com listen: false para não precisar usar o didChangeDependencies
  // Ou
  // Future.delayed(Duration.zero).then((_) {
  //   Provider.of<Scenes>(context).fetchAndSetScenes();
  // });
  // super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       //para atualizar a UI
  //       _isLoading = true;
  //     });
  //     //fetch data
  //     Provider.of<Scenes>(context).fetchAndSetScenes().then((_) {
  //       setState(() {
  //         //para atualizar a UI
  //         _isLoading = false;
  //       });
  //     });
  //   }

  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // Fetch de todos os dados necessários do firebase
      Provider.of<Devices>(context).fetchAndSetDevices();
      Provider.of<Categories>(context).fetchAndSetCategories();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suas cenas'),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(EditDeviceScreen.routeName);
          //   },
          //   icon: const Icon(Icons.wb_incandescent_sharp),
          //   tooltip: 'Dispositivos',
          // ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(EditEnvironmentScreen.routeName);
          //   },
          //   icon: const Icon(Icons.apartment_rounded),
          //   tooltip: 'Ambientes',
          // ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Suas cenas aqui!'),
      ),
    );
  }
}
