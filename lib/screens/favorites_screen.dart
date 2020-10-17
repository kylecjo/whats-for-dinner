import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';
import '../providers/favorites.dart';

class FavoritesScreen extends StatelessWidget {
  final String title;
  static const routeName = '/favorites';

  FavoritesScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<Favorites>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: favs.favorites.length > 0
            ? ListView.builder(
                itemCount: favs.favorites.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return RestaurantCard(business: favs.favorites[index], cardColor: Colors.white);
                },
              )
            : Text('You have no favorites!'),
      ),
    );
  }
}
