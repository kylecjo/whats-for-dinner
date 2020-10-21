import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/business.dart';
import '../models/choose_one_arguments.dart';
import '../providers/favorites.dart';
import '../widgets/restaurant_card.dart';
import 'choose_one_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final String title;
  static const routeName = '/favorites';

  FavoritesScreen(this.title);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void chooseOne(List<Business> businesses, String errorText) {
    try {
      Navigator.pushNamed(
        context,
        ChooseOneScreen.routeName,
        arguments: ChooseOneArguments(businesses),
      );
    } catch (_) {
      final snackBar = SnackBar(
        content: Text(errorText),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<Favorites>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          InkWell(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Icon(Icons.casino)),
              onTap: () {
                chooseOne(favs.favorites, 'You have no favorites');
              }),
        ],
      ),
      body: Center(
        child: favs.favorites.length > 0
            ? ListView.builder(
                itemCount: favs.favorites.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return RestaurantCard(
                      business: favs.favorites[index], cardColor: Colors.white);
                },
              )
            : Text('You have no favorites!'),
      ),
    );
  }
}
