import 'package:HomeSet/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import './providers/auth.dart';
import './providers/device.dart';
import './providers/devices.dart';
import './providers/scenes.dart';

//Screens
import './screens/auth_screen.dart';
import './screens/scenes_overview_screen.dart';
import './screens/user_devices_screen.dart';
import './screens/edit_device_screen.dart';
import './screens/general_devices_categories_screen.dart';
import './screens/edit_device_category_screen.dart';

// Others
import 'theme.dart';

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
            value: Devices(),
          ),
          ChangeNotifierProvider.value(
            value: Categories(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'HomeSet',
            themeMode: ThemeMode.system,
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
            },
          ),
        ));
  }
}
