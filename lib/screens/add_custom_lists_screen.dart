import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/custom_lists.dart';
import '../screens/custom_list_screen.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/favorite_list_tile.dart';

class AddCustomListsScreen extends StatefulWidget {
  final String title;
  static const routeName = '/addCustomLists';

  AddCustomListsScreen(this.title);

  @override
  _AddCustomListsScreenState createState() => _AddCustomListsScreenState();
}

class _AddCustomListsScreenState extends State<AddCustomListsScreen> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final customListProvider = Provider.of<CustomLists>(context);
    final authProvider = Provider.of<Auth>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: InkWell(
                  child: Text('+ New List',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 13, color: Colors.teal)),
                  onTap: () {
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
                                  customListProvider.addCustomList(
                                      authProvider.uid, textController.text);
                                  textController.clear();
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }),
            ),
            FavoriteListTile(),
            Expanded(
              child: ListView.builder(
                itemCount: customListProvider.customLists.length,
                itemBuilder: (BuildContext ctx, int idx) {
                  // https://stackoverflow.com/questions/59499302/flutter-container-listview-scrollable
                  // a hack to have a widget scrollable with listview
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => CustomListScreen(
                                  customListProvider.customLists[idx])));
                    },
                    child: CustomListTile(
                      name: customListProvider.customLists[idx].name,
                      listLength:
                          customListProvider.customLists[idx].businesses.length,
                      id: customListProvider.customLists[idx].id,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
