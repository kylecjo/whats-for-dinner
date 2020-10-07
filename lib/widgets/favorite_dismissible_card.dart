import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/business.dart';
import '../providers/businesses.dart';
import '../widgets/restaurant_card.dart';

class FavoriteDismissibleCard extends StatelessWidget {
  final Business business;

  FavoriteDismissibleCard(this.business);

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);
    return Dismissible(
        key: Key(business.id.toString()),
        background: Container(color: Theme.of(context).backgroundColor),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          businessList.removeFavorite(business);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('$business hidden'),
              action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    businessList.removeHidden(business);
                    businessList.addFavorite(business);
                  }),
            ),
          );
        },
        child:
            RestaurantCard(business: business, cardColor: Color(0xffa4d1a2)));
  }
}
