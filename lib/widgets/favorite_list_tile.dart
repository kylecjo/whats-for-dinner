import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/providers/favorites.dart';
import 'package:whats_for_dinner/screens/favorites_screen.dart';

class FavoriteListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => FavoritesScreen('Favorites'),
          ),
        );
      },
      child: FutureBuilder(
        future:  Provider.of<Favorites>(context, listen: false).fetchAndSetFavorites(Provider.of<Auth>(context, listen: false).uid),
        builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,));
        } else {
          if (snapshot.error != null) {
            return Center(child: Text('There was an error loading favorites'));
          } else {
            return Consumer<Favorites>(
              builder: (ctx, favoritesProvider, _) => Card(
                elevation: 1,
                child: ListTile(
                  leading: Icon(Icons.favorite, color: Colors.red),
                  title: Text(
                    'Favorites',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text('${favoritesProvider.favorites.length} items'),
                ),
              ),
            );
          }
        }
      }),
    );
  }
}
