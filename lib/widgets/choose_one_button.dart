import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../providers/businesses.dart';

class ChooseOneButton extends StatelessWidget {
  final Random rnd = new Random();

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);

    return FloatingActionButton(
      onPressed: () {
        try {
          int randomIndex = rnd.nextInt(businessList.favorites.length);
          final snackBar = SnackBar(
              content: Text(businessList.favorites[randomIndex].toString()));
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
