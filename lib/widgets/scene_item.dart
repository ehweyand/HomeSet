import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/scene.dart';

import '../screens/scene_management_screen.dart';

class SceneItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scene = Provider.of<Scene>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            // Navega para a tela de configuracoes da cena e apresenta as configurações possíveis lá
            Navigator.of(context).pushNamed(
              SceneManagementScreen.routeName,
              arguments: scene
                  .id, // id para recuperar os dados da respectiva cena pela rota
            );
          },
          child: Image.network(
            'https://cdn.pixabay.com/photo/2016/06/01/17/43/house-1429409_1280.png',
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // Aqui abaixo a lógica de marcar favorito e enviar ao servidor
          leading: IconButton(
            icon: Icon(Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: () {
              //scene.toggleFavoriteStatus();
            },
          ),
          title: Text(
            scene.nickname,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
