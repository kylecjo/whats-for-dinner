import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String name;

  CustomListTile(this.name);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.directions_bike),
      title: Text(name),
    );
  }
}
