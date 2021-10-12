import 'package:HomeSet/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/scenes_grid.dart';

import '../providers/scenes.dart';
import '../providers/devices.dart';

import '../screens/edit_scene_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ScenesOverviewScreen extends StatefulWidget {
  @override
  _ScenesOverviewScreenState createState() => _ScenesOverviewScreenState();
}

class _ScenesOverviewScreenState extends State<ScenesOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  // Filtro de favoritos
  var _showOnlyFavorites = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // Fetch de todos os dados necessários do firebase
      Provider.of<Devices>(context).fetchAndSetDevices();
      Provider.of<Categories>(context).fetchAndSetCategories();
      // Para aparecer as cenas, manipular a tela de loading...
      setState(() {
        _isLoading = true;
      });
      Provider.of<Scenes>(context).fetchAndSetScenes().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
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
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditSceneScreen.routeName);
            },
            icon: const Icon(Icons.add),
            tooltip: 'Criar nova cena',
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          //widget personalizado, depois pode ser incrementado para mostrar apenas favoritos ou outros filtros.
          : ScenesGrid(),
    );
  }
}
