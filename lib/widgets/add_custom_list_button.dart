import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/custom_lists.dart';

class AddCustomListButton extends StatelessWidget {
  final textController;

  AddCustomListButton(this.textController);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: RaisedButton(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.teal),
          ),
          child: Text('+ New List',
              style: Theme.of(context).textTheme.headline3.copyWith(
                  fontSize: 13,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Enter list name',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 15)),
                    content: TextField(
                      controller: textController,
                      textInputAction: TextInputAction.go,
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text('Submit'),
                        onPressed: () {
                          Provider.of<CustomLists>(context, listen: false)
                              .addCustomList(authProvider.uid,
                                  authProvider.email, textController.text);
                          textController.clear();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          }),
    );
  }
}
