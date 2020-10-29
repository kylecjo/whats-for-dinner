import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/business.dart';
import '../models/custom_list.dart';
import '../providers/auth.dart';
import '../providers/custom_lists.dart';
import '../widgets/restaurant_card.dart';

class CustomListDismissibleCard extends StatelessWidget {
  final Business business;
  final CustomList customList;

  CustomListDismissibleCard(this.business, this.customList);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Consumer<CustomLists>(
      builder: (context, customListProvider, child) => Dismissible(
        key: Key(business.id.toString()),
        background: Container(color: Theme.of(context).backgroundColor),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          customListProvider.removeFromCustomList(
              authProvider.uid, customList, business);
        },
        child: RestaurantCard(business: business),
      ),
    );
  }
}
