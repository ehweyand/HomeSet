import './screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth.dart';

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
      ],
      child: MaterialApp(
        title: 'HomeSet',
        themeMode: ThemeMode.system,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
        routes: {},
      ),
    );
  }
}
