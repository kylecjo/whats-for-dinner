import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/custom_lists.dart';
import '../screens/custom_list_screen.dart';
import '../widgets/add_custom_list_button.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/favorite_list_tile.dart';

class AddCustomListsScreen extends StatelessWidget {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Your lists'),
        ),
        body: FutureBuilder(
            future: Provider.of<CustomLists>(context, listen: false)
                .fetchAndSetCustomLists(authProvider.uid),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ));
              } else {
                if (snapshot.error != null) {
                  return Center(
                      child: Text('There was an error loading favorites'));
                } else {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AddCustomListButton(textController),
                        FavoriteListTile(),
                        Expanded(
                          child: Consumer<CustomLists>(
                            builder: (ctx, customListProvider, _) =>
                                ListView.builder(
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
                                                customListProvider
                                                    .customLists[idx])));
                                  },
                                  child: CustomListTile(
                                    name: customListProvider
                                        .customLists[idx].name,
                                    listLength: customListProvider
                                        .customLists[idx].businesses.length,
                                    id: customListProvider.customLists[idx].id,
                                    uid:
                                        customListProvider.customLists[idx].uid,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ]);
                }
              }
            }),
      ),
    );
  }
}
