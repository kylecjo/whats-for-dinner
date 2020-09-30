import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/business.dart';
import '../providers/businesses.dart';
import '../widgets/restaurant_card.dart';

enum RestaurantVisibility {
  hidden,
  visible,
  favorite,
  search,
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
          key: Key(business.id.toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            businessList.removeFavorite(business);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('$business hidden'),
                action: SnackBarAction(label: 'Undo', onPressed: () {
                  businessList.removeHidden(business);
                  businessList.addFavorite(business);
                }),
              ),
            );
          },
          child:
              RestaurantCard(business: business, cardColor: Color(0xffa4d1a2)));
    } else if (visibility == RestaurantVisibility.hidden) {
      return Dismissible(
          key: Key(business.id.toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            businessList.removeHidden(business);
          },
          child:
              RestaurantCard(business: business, cardColor: Colors.grey[300]));
    } else if (visibility == RestaurantVisibility.search) {
      return Dismissible(
          key: Key(business.id.toString()),
          background: Container(color: Theme.of(context).backgroundColor),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            businessList.removeSearch(business);

            
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('$business hidden'),
                action: SnackBarAction(label: 'Undo', onPressed: () {
                  businessList.removeHidden(business);
                  businessList.addSearch(business);
                }),
              ),
            );
          },
          child:
              RestaurantCard(business: business, cardColor: Colors.blue[200]));
    } else {
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
                action: SnackBarAction(label: 'Undo', onPressed: () {
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
}
