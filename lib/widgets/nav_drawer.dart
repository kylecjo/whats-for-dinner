import 'package:flutter/material.dart';
import 'package:whats_for_dinner/screens/add_custom_lists_screen.dart';

import '../screens/favorites_screen.dart';
import '../screens/hidden_screen.dart';
import '../screens/search_screen.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'What\'s for Dinner?',
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 22),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          NavDrawerTile(
            icon: Icons.near_me,
            title: 'Near me',
            iconColor: Colors.red,
            tapHandler: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          NavDrawerTile(
            icon: Icons.star,
            title: 'Favorites',
            iconColor: Colors.yellow,
            tapHandler: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushReplacementNamed(FavoritesScreen.routeName);
            },
          ),
          NavDrawerTile(
            icon: Icons.search,
            title: 'Search',
            iconColor: Colors.blue,
            tapHandler: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushReplacementNamed(SearchScreen.routeName);
            },
          ),
          NavDrawerTile(
            icon: Icons.delete,
            title: 'Hidden',
            iconColor: Colors.grey,
            tapHandler: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushReplacementNamed(HiddenScreen.routeName);
            },
          ),
          NavDrawerTile(
            icon: Icons.add,
            title: 'Custom lists',
            iconColor: Colors.green,
            tapHandler: () {
              Navigator.of(context)
                  .pushReplacementNamed(AddCustomListsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class NavDrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final Function tapHandler;

  NavDrawerTile(
      {@required this.icon,
      @required this.title,
      @required this.iconColor,
      @required this.tapHandler});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
        size: 26,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 20),
      ),
      onTap: tapHandler,
    );
  }
}
