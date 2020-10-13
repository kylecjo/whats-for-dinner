import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/custom_list.dart';
import 'package:whats_for_dinner/providers/custom_lists.dart';

import '../models/business.dart';
import '../widgets/restaurant_card.dart';

class CustomListDismissibleCard extends StatelessWidget {
  final Business business;
  final CustomList customList;

  CustomListDismissibleCard(this.business, this.customList);

  @override
  Widget build(BuildContext context) {

    return Consumer<CustomLists>(
      builder: (context, customListProvider, child) => Dismissible(
          key: Key(business.id.toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            customListProvider.removeFromCustomList(customList, business);
          },
          child: RestaurantCard(
              business: business, cardColor: Theme.of(context).accentColor)),
    );
  }
}
