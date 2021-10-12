import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../constants.dart';
import 'scene.dart';

class Scenes with ChangeNotifier {
  List<Scene> _items = [];

  List<Scene> get items {
    return [..._items];
  }

  Scene findById(String id) {
    return _items.firstWhere((scene) => scene.id == id);
  }

  Future<void> fetchAndSetScenes() async {
    var url = Uri.https(firebaseUrl, 'scenes.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Scene> loadedScenes = [];

      extractedData.forEach((sceneId, sceneData) {
        loadedScenes.add(new Scene(
          id: sceneId,
          nickname: sceneData['nickname'],
          description: sceneData['description'],
          isFavorite: sceneData['isFavorite'],
        ));
      });
      _items = loadedScenes;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addScene(Scene scene) async {
    var url = Uri.https(firebaseUrl, 'scenes.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'nickname': scene.nickname,
          'description': scene.description,
          'isFavorite': scene.isFavorite,
        }),
      );
      print(response.body);
      final newScene = Scene(
        nickname: scene.nickname,
        description: scene.description,
        isFavorite: false,
        id: json.decode(response.body)['name'],
      );
      // _items.add(newScene);
      _items.insert(0, newScene); //adiciona no começo da lista
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteScene(String id) async {
    final url = Uri.https(firebaseUrl, '/scenes/$id.json');
    final existingSceneIndex = _items.indexWhere((scene) => scene.id == id);
    var existingScene = _items[existingSceneIndex];
    _items.removeAt(existingSceneIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingSceneIndex, existingScene);
      notifyListeners();
      throw HttpException('Não foi possível deletar a cena.');
    }
    existingScene = null;
  }
}
