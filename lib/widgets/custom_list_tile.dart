import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/providers/custom_lists.dart';

class CustomListTile extends StatelessWidget {
  final String name;
  final int listLength;
  final String id;

  CustomListTile({@required this.name, @required this.listLength, @required  this.id});

  @override
  Widget build(BuildContext context) {
    final customListProvider = Provider.of<CustomLists>(context);
    final authProvider = Provider.of<Auth>(context);
    return Card(
      elevation: 1,
      child: ListTile(
        leading: Icon(Icons.fastfood, color: Colors.grey[500]),
        title: Text(name, style: Theme.of(context).textTheme.headline5),
        subtitle: Text('$listLength items'),
        trailing: GestureDetector(
          child: Icon(Icons.delete),
          onTap: () {
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Warning',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      'You are about to delete $name and all of its contents',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    actions: [
                      FlatButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop()),
                      FlatButton(
                          child: Text('Continue'),
                          onPressed: () {
                            customListProvider.removeCustomList(authProvider.uid, id);
                            Navigator.of(context).pop();
                          }),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {}
}
