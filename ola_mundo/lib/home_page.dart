import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app_controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int count = 0;
  bool isDarkTheme = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Switch(
            value: AppController.instance.isDartTheme,
            onChanged: (value) {
              AppController.instance.changeTheme();
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              count++;
            });
          }),
    );
  }
}
