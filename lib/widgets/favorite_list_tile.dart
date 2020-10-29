import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/favorites.dart';
import '../screens/favorites_screen.dart';

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
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
                  ),
                  subtitle: Text('${favoritesProvider.favorites.length} items'),
                ),
              ),
            );
          }
      }),
    );
  }
}
