import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/favorites.dart';
import 'package:whats_for_dinner/screens/favorites_screen.dart';

class FavoriteListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<Favorites>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => FavoritesScreen('Favorites'),
          ),
        );
      },
      child: Card(
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
