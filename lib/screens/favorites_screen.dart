import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/screen_type.dart';
import 'package:whats_for_dinner/providers/businesses.dart';
import 'package:whats_for_dinner/widgets/choose_one_button.dart';
import 'package:whats_for_dinner/widgets/dismissible_card.dart';
import 'package:whats_for_dinner/widgets/nav_drawer.dart';

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
                  return DismissibleCard(businesses.favorites[index], RestaurantVisibility.favorite);
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
