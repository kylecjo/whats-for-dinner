import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import '../providers/favorites.dart';

import '../models/business.dart';
import '../widgets/restaurant_card.dart';

class FavoriteDismissibleCard extends StatelessWidget {
  final Business business;

  FavoriteDismissibleCard(this.business);

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<Favorites>(context);
    final authProvider = Provider.of<Auth>(context);
    return Dismissible(
        key: Key(business.id.toString()),
        background: Container(color: Theme.of(context).backgroundColor),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          favs.removeFavorite(business, authProvider.uid);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('$business removed from favorites'),
              action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                   favs.addFavorite(business, authProvider.uid);
                  }),
            ),
          );
        },
        child:
            RestaurantCard(business: business, cardColor: Color(0xffa4d1a2)));
  }
}
