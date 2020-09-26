import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/business.dart';
import '../widgets/restaurant_card.dart';
import '../providers/businesses.dart';

enum RestaurantVisibility {
  hidden,
  visible,
  favorite,
}

class DismissibleCard extends StatelessWidget {
  final RestaurantVisibility visibility;
  final Business business;

  DismissibleCard(this.business, this.visibility);

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);

    if (visibility == RestaurantVisibility.favorite) {
      return Dismissible(
          key: Key(business.toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            businessList.removeFavorite(business);
          },
          child: RestaurantCard(business: business, cardColor: Color(0xffa4d1a2)));
    } else if(visibility == RestaurantVisibility.hidden){
      return Dismissible(
          key: Key(business.toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            businessList.removeHidden(business);
          },
          child: RestaurantCard(business: business, cardColor: Colors.grey[300]));

    } else {
      return Dismissible(
          key: Key(business.toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {

              businessList.addHidden(business);
              businessList.removeBusiness(business);
            }

            if (direction == DismissDirection.startToEnd) {

              businessList.addFavorite(business);
              businessList.removeBusiness(business);
            }
          },
          child: RestaurantCard(business: business, cardColor: Theme.of(context).accentColor));
    }
  }
}
