import 'package:flutter/material.dart';

class EditEnvironmentScreen extends StatefulWidget {
  static const routeName = '/edit-environment';

  @override
  _EditEnvironmentState createState() => _EditEnvironmentState();
}

class _EditEnvironmentState extends State<EditEnvironmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lorem ipsum Environment'),
      ),
    );
  }
}
