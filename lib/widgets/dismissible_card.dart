import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/restaurant_card.dart';
import '../providers/businesses.dart';

class DismissibleCard extends StatelessWidget {
  final int index;

  DismissibleCard(this.index);

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);

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
          print('favorites: ${businessList.favorites}');
          print('hidden: ${businessList.hidden}');
        },
        child: RestaurantCard(businessList.businesses[index]));
  }
}
