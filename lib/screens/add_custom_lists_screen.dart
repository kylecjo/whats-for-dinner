import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/businesses.dart';
import 'package:whats_for_dinner/screens/custom_list_screen.dart';
import 'package:whats_for_dinner/widgets/custom_list_tile.dart';
import 'package:whats_for_dinner/widgets/nav_drawer.dart';

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
    final businesses = Provider.of<Businesses>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
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
                      businesses.addCustomList(textController.text);
                      textController.clear();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: businesses.customLists.isNotEmpty
                  ? ListView.builder(
                      itemCount: businesses.customLists.length,
                      itemBuilder: (BuildContext ctx, int idx) {
                        String key = businesses.customLists.keys.elementAt(idx);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => CustomListScreen(key)));
                          },
                          child: CustomListTile(
                              key, businesses.customLists[key].length),
                        );
                      })
                  : Center(child: Text('No custom lists yet')),
            ),
          ],
        ),
        drawer: NavDrawer(),
      ),
    );
  }
}
