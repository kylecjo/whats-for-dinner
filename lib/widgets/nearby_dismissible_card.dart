import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/business.dart';
import '../providers/businesses.dart';
import '../widgets/restaurant_card.dart';

class NearbyDismissibleCard extends StatelessWidget {
  final Business business;

  NearbyDismissibleCard(this.business);

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);

    return Dismissible(
        key: Key(business.id.toString()),
        background: Container(color: Theme.of(context).backgroundColor),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          businessList.addHidden(business);
          businessList.removeBusiness(business);

          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('$business hidden'),
              action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    businessList.removeHidden(business);
                    businessList.addBusiness(business);
                  }),
            ),
          );
        },
        child: RestaurantCard(
            business: business, cardColor: Theme.of(context).accentColor));
  }
}
