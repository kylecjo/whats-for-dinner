import 'dart:math';

import 'package:flutter/material.dart';

import '../models/business.dart';
import '../models/choose_one_arguments.dart';
import '../models/screen_type.dart';
import '../screens/choose_one_screen.dart';

class ChooseOneButton extends StatelessWidget {
  final Random rnd = new Random();
  final List<Business> list;
  final Color color;
  final String errorText;
  final ScreenType screenType;

  ChooseOneButton(
      {@required this.list, @required this.color, @required this.errorText, @required this.screenType});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: color,
      onPressed: () {
        try {
          int randomIndex = rnd.nextInt(list.length);
          Navigator.pushNamed(
            context,
            ChooseOneScreen.routeName,
            arguments: ChooseOneArguments(list[randomIndex], screenType),
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
