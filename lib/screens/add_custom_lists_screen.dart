import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/providers/custom_lists.dart';
import 'package:whats_for_dinner/providers/favorites.dart';
import 'package:whats_for_dinner/screens/custom_list_screen.dart';
import 'package:whats_for_dinner/widgets/custom_list_tile.dart';
import 'package:whats_for_dinner/widgets/favorite_list_tile.dart';
import '../screens/favorites_screen.dart';

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
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'List Name',
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Add'),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      customListProvider.addCustomList(
                          authProvider.uid, textController.text);
                      textController.clear();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: customListProvider.customLists.length,
                itemBuilder: (BuildContext ctx, int idx) {
                  // https://stackoverflow.com/questions/59499302/flutter-container-listview-scrollable
                  // a hack to have a widget scrollable with listview
                  if (idx == 0) {
                    return FavoriteListTile();
                  } else {
                    idx = idx - 1;
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
                        listLength: customListProvider
                            .customLists[idx].businesses.length,
                        id: customListProvider.customLists[idx].id,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
