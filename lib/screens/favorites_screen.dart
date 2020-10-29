import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/reroll_icon.dart';

import '../providers/favorites.dart';
import '../widgets/restaurant_card.dart';

class FavoritesScreen extends StatefulWidget {
  final String title;
  static const routeName = '/favorites';

  FavoritesScreen(this.title);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<Favorites>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          RerollIcon(favs.favorites, 'You have no favorites!'),
        ],
      ),
      body: Center(
        child: favs.favorites.length > 0
            ? ListView.builder(
                itemCount: favs.favorites.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return RestaurantCard(
                    business: favs.favorites[index],
                  );
                },
              )
            : Text('You have no favorites!'),
      ),
    );
  }
}
