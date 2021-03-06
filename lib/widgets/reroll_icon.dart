import 'package:flutter/material.dart';
import '../screens/choose_one_screen.dart';

class RerollIcon extends StatelessWidget {
  final businesses;
  final errorText;

  RerollIcon(this.businesses, this.errorText);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Icon(Icons.casino,
                color: Theme.of(context).primaryIconTheme.color)),
        onTap: () {
          if (businesses.length > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChooseOneScreen(businesses),
              ),
            );
          } else {
            final snackBar = SnackBar(
              content: Text(errorText),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          }
        });
  }
}
