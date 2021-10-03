import 'package:flutter/cupertino.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/category.dart';

import '../constants.dart';

class Categories with ChangeNotifier {
  List<Category> _items = [];

  List<Category> get items {
    return [..._items];
  }

  Category findById(String id) {
    return _items.firstWhere((category) => category.id == id);
  }

  Future<void> fetchAndSetCategories() async {
    var url = Uri.https(firebaseUrl, 'categories.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Category> loadedCategories = [];
      extractedData.forEach((categoryId, categoryData) {
        loadedCategories.add(new Category(
          id: categoryId,
          description: categoryData['description'],
        ));
      });
      _items = loadedCategories;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCategory(Category category) async {
    var url = Uri.https(firebaseUrl, 'categories.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'description': category.description,
        }),
      );
      final newCategory = Category(
        description: category.description,
        id: json.decode(response.body)['name'],
      );
      _items.add(newCategory);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCategory(String id, Category newCategory) async {
    final categoryIndex = _items.indexWhere((category) => category.id == id);
    if (categoryIndex >= 0) {
      final url = Uri.https(firebaseUrl, '/categories/$id.json');
      await http.patch(url,
          body: json.encode({
            'description': newCategory.description,
          }));

      _items[categoryIndex] = newCategory;
      notifyListeners();
    } else {
      print('Erro: Categoria não encontrada para atualizar.');
    }
  }

  Future<void> deleteCategory(String id) async {
    final url = Uri.https(firebaseUrl, '/categories/$id.json');
    final existingCategoryIndex =
        _items.indexWhere((category) => category.id == id);
    var existingCategory = _items[existingCategoryIndex];
    _items.removeAt(existingCategoryIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingCategoryIndex, existingCategory);
      notifyListeners();
      throw HttpException('Não foi possível deletar a categoria.');
    }

    existingCategory = null;
  }
}
