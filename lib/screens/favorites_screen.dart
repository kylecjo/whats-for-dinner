import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/widgets/favorite_dismissible_card.dart';

import '../models/screen_type.dart';
import '../providers/businesses.dart';
import '../widgets/choose_one_button.dart';
import '../widgets/nav_drawer.dart';

class FavoritesScreen extends StatelessWidget {
  final String title;
  static const routeName = '/favorites';

  FavoritesScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final businesses = Provider.of<Businesses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: businesses.favorites.length > 0
            ? ListView.builder(
                itemCount: businesses.favorites.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return FavoriteDismissibleCard(businesses.favorites[index]);
                },
              )
            : Text('You have no favorites!'),
      ),
      drawer: NavDrawer(),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return ChooseOneButton(
            list: businesses.favorites,
            color: Theme.of(context).accentColor,
            errorText: 'You have no favorites!',
            screenType: ScreenType.favorites,
          );
        },
      ),
    );
  }
}
