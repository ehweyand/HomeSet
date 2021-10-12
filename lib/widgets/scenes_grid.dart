import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scenes.dart';
import './scene_item.dart';

class ScenesGrid extends StatelessWidget {
  // final bool showFavs;

  // ScenesGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final scenesData = Provider.of<Scenes>(context);
    final scenes = /*showFavs ? scenesData.favoriteItems :*/ scenesData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: scenes.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: scenes[i],
        child: SceneItem(),
      ),
      // Configurações do grid
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
