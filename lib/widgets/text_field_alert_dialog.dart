import 'package:flutter/material.dart';

class TextFieldAlertDialog extends StatelessWidget {
  final TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('What is your Lucky Number'),
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(hintText: "Enter your number"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alert Dilaog with TestFiled'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Enter your list name',style: TextStyle(color: Colors.white),),
          color: Colors.pink,
          onPressed: () => _displayDialog(context),
        ),
      ),
    );
  }
}