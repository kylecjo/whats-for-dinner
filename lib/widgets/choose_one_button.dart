import 'package:flutter/material.dart';
import 'package:whats_for_dinner/models/business.dart';
import 'dart:math';

class ChooseOneButton extends StatelessWidget {
  final Random rnd = new Random();
  final List<Business> chooseOneFromThisList;
  final Color color;

  ChooseOneButton(this.chooseOneFromThisList, this.color);

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      backgroundColor: color,
      onPressed: () {
        try {
          int randomIndex = rnd.nextInt(chooseOneFromThisList.length);
          final snackBar = SnackBar(
              content: Text(chooseOneFromThisList[randomIndex].toString()));
          Scaffold.of(context).showSnackBar(snackBar);
        } catch (_) {
          final snackBar = SnackBar(
            content: Text('You have no favorites!'),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      child: Icon(Icons.shuffle),
    );
  }
}
