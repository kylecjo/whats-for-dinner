import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/restaurant_card.dart';
import '../providers/businesses.dart';

enum RestaurantVisibility {
  hidden,
  visible,
  favorite,
}

class DismissibleCard extends StatelessWidget {
  final RestaurantVisibility visibility;
  final int index;

  DismissibleCard(this.index, this.visibility);

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);

    if (visibility == RestaurantVisibility.favorite) {
      return Dismissible(
          key: Key(businessList.businesses[index].toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            businessList.removeFavorite(businessList.favorites[index]);
          },
          child: RestaurantCard(business: businessList.favorites[index], cardColor: Color(0xffa4d1a2)));
    } else {
      return Dismissible(
          key: Key(businessList.businesses[index].toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              if (!businessList.hidden.any((business) =>
                  business.id == businessList.businesses[index].id)) {
                businessList.addHidden(businessList.businesses[index]);
              }
              businessList.removeBusiness(businessList.businesses[index]);
            }

            if (direction == DismissDirection.startToEnd) {
              if (!businessList.favorites.any((business) =>
                  business.id == businessList.businesses[index].id)) {
                businessList.addFavorite(businessList.businesses[index]);
              }
              businessList.removeBusiness(businessList.businesses[index]);
            }
            // print('favorites: ${businessList.favorites}');
            // print('hidden: ${businessList.hidden}');
          },
          child: RestaurantCard(business: businessList.businesses[index], cardColor: Theme.of(context).accentColor));
    }
  }
}
