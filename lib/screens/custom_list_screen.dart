import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/custom_list.dart';
import '../providers/custom_lists.dart';
import '../widgets/custom_list_dismissible_card.dart';
import '../widgets/reroll_icon.dart';
import '../widgets/share_icon.dart';

class CustomListScreen extends StatefulWidget {
  final CustomList customList;
  static const routeName = '/customList';

  CustomListScreen(this.customList);

  @override
  _CustomListScreenState createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.customList.name),
        actions: [
          RerollIcon(widget.customList.businesses,
              'There are no items in ${widget.customList.name}!'),
          ShareIcon(widget.customList),
        ],
      ),
      body: Consumer<CustomLists>(
        builder: (ctx, data, child) => Column(
          children: [
            Expanded(
              child: widget.customList.businesses.length > 0
                  ? ListView.builder(
                      itemCount: widget.customList.businesses.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return CustomListDismissibleCard(
                            widget.customList.businesses[index],
                            widget.customList);
                      },
                    )
                  : Center(
                      child: Text(
                          'No restaurants in ${widget.customList.name} yet!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 14))),
            ),
          ],
        ),
      ),
    );
  }
}
