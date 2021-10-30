import 'package:HomeSet/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import './providers/auth.dart';
import './providers/devices.dart';
import './providers/scenes.dart';

//Screens
import './screens/auth_screen.dart';
import './screens/scenes_overview_screen.dart';
import './screens/edit_scene_screen.dart';
import './screens/user_devices_screen.dart';
import './screens/edit_device_screen.dart';
import './screens/general_devices_categories_screen.dart';
import './screens/edit_device_category_screen.dart';
import './screens/scene_management_screen.dart';

// Others
import './providers/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProvider.value(
            value: ThemeProvider(),
          ),
          ChangeNotifierProvider.value(
            value: Scenes(),
          ),
          ChangeNotifierProvider.value(
            value: Devices(),
          ),
          ChangeNotifierProvider.value(
            value: Categories(),
          ),
        ],
        // existem vários consumers, 2, 3, 4, dependendo de quantos providers vai usar
        child: Consumer2<Auth, ThemeProvider>(
          builder: (ctx, auth, themeProvider, _) => MaterialApp(
            title: 'HomeSet',
            themeMode: themeProvider.themeMode,
            theme: lightThemeData(context),
            darkTheme: darkThemeData(context),
            debugShowCheckedModeBanner: false,
            home: auth.isAuth ? ScenesOverviewScreen() : AuthScreen(),
            routes: {
              UserDevicesScreen.routeName: (ctx) => UserDevicesScreen(),
              EditDeviceScreen.routeName: (ctx) => EditDeviceScreen(),
              GeneralDevicesCategoriesScreen.routeName: (ctx) =>
                  GeneralDevicesCategoriesScreen(),
              EditDeviceCategoryScreen.routeName: (ctx) =>
                  EditDeviceCategoryScreen(),
              EditSceneScreen.routeName: (ctx) => EditSceneScreen(),
              SceneManagementScreen.routeName: (ctx) => SceneManagementScreen(),
            },
          ),
        ));
  }
}
