import 'package:flutter/material.dart';
import '../models/business.dart';

import '../widgets/restaurant_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Business> favorites;
  final String title;

  FavoritesScreen(this.title, this.favorites);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$this.title',)
      ),
      body: Center(
        child: favorites != null
            ? ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (BuildContext ctx, int index) {
                      return RestaurantCard(favorites[index]);
                },
              )
            : Text('Press the button to load restaurants'),
      ),
    );
  }
}