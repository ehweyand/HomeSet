import 'package:HomeSet/widgets/general_category_device_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';

import '../widgets/app_drawer.dart';

import '../screens/edit_device_category_screen.dart';

class GeneralDevicesCategoriesScreen extends StatelessWidget {
  static const routeName = '/general-categories';

  Future<void> _refreshCategories(BuildContext context) async {
    await Provider.of<Categories>(context, listen: false)
        .fetchAndSetCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<Categories>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias disponíveis'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditDeviceCategoryScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshCategories(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: categoriesData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                GeneralCategoryDeviceItem(
                  categoriesData.items[i].id,
                  categoriesData.items[i].description,
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
