import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/custom_lists.dart';

class CustomListTile extends StatelessWidget {
  final String name;
  final int listLength;
  final String id;
  final String uid;

  CustomListTile({@required this.name, @required this.listLength, @required  this.id, @required this.uid});

  @override
  Widget build(BuildContext context) {
    final customListProvider = Provider.of<CustomLists>(context);
    final authProvider = Provider.of<Auth>(context);
    return Card(
      elevation: 1,
      child: ListTile(
        leading: Icon(Icons.list, color: Colors.teal),
        title: Text(name, style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.black,
                        fontSize: 14,
                      ),),
        subtitle: Text('$listLength restaurants'),
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
                      authProvider.uid == uid ? 'You are about to delete $name and all of its contents' : 'After deleting $name you will not be able to view its contents',
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
                            customListProvider.removeCustomList(authProvider.uid, id, uid);
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
