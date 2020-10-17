import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites.dart';
import 'package:whats_for_dinner/widgets/favorite_dismissible_card.dart';

import '../models/screen_type.dart';
import '../widgets/choose_one_button.dart';
import '../widgets/nav_drawer.dart';

class FavoritesScreen extends StatelessWidget {
  final String title;
  static const routeName = '/favorites';

  FavoritesScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<Favorites>(context);
    return Center(
        child: favs.favorites.length > 0
            ? ListView.builder(
                itemCount: favs.favorites.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return FavoriteDismissibleCard(favs.favorites[index]);
                },
              )
            : Text('You have no favorites!'),
      );
  }
}
