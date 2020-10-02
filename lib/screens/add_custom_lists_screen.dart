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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // TODO:  style all of this
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'List Name',
              ),
            ),
          ),
          RaisedButton(
            child: Text('Add'),
            onPressed: () {
              businesses.addCustomList(textController.text);
              textController.clear();
            },
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
                        child: CustomListTile(key),
                      );
                    })
                : Text('No custom lists yet'),
          ),
        ],
      ),
      drawer: NavDrawer(),
    );
  }
}
