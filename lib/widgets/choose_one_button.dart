import 'package:flutter/material.dart';
import 'package:whats_for_dinner/models/business.dart';
import 'package:whats_for_dinner/models/choose_one_arguments.dart';
import 'dart:math';

import 'package:whats_for_dinner/screens/choose_one_screen.dart';

class ChooseOneButton extends StatelessWidget {
  final Random rnd = new Random();
  final List<Business> list;
  final Color color;
  final String errorText;

  ChooseOneButton(
      {@required this.list, @required this.color, @required this.errorText});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color,
      onPressed: () {
        try {
          int randomIndex = rnd.nextInt(list.length);
          // final snackBar =
          //     SnackBar(content: Text(list[randomIndex].toString()));
          // Scaffold.of(context).showSnackBar(snackBar);
          Navigator.pushNamed(
            context,
            ChooseOneScreen.routeName,
            arguments: ChooseOneArguments(list[randomIndex]),
          );
        } catch (_) {
          final snackBar = SnackBar(
            content: Text(errorText),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      child: Icon(Icons.shuffle),
    );
  }
}
