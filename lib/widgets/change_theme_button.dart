import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return SwitchListTile(
        title: const Text('Alterar tema'),
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          final provider = Provider.of<ThemeProvider>(context, listen: false);
          provider.toggleTheme(value);
        },
        secondary: const Icon(Icons.lightbulb_outline));
  }
}
