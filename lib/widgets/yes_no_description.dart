import 'package:flutter/material.dart';
import '../models/business.dart';

class YesNoDescription extends StatelessWidget {
  final Business business;
  final String description;
  YesNoDescription(this.business, this.description);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        business.isClosed
            ? Icon(
                Icons.close,
                color: Colors.red,
                size: 20.0,
              )
            : Icon(
                Icons.check,
                color: Colors.green,
                size: 20.0,
              ),
        Text(description, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }
}
