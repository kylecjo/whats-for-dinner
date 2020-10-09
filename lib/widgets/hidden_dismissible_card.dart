import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/business.dart';
import '../providers/businesses.dart';
import '../widgets/restaurant_card.dart';

class HiddenDismissibleCard extends StatelessWidget {
  final Business business;

  HiddenDismissibleCard(this.business);

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);

    return Dismissible(
        key: Key(business.id.toString()),
        background: Container(color: Theme.of(context).backgroundColor),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          businessList.removeHidden(business);
        },
        child: RestaurantCard(business: business, cardColor: Colors.grey[300]));
  }
}
