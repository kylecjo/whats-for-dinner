import 'package:flutter/material.dart';
import 'package:whats_for_dinner/screens/favorites_screen.dart';
import 'package:whats_for_dinner/screens/hidden_screen.dart';

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
              'What\'s for dinner?',
              style:
                  Theme.of(context).textTheme.headline6.copyWith(fontSize: 22),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          NavDrawerTile(
            icon: Icons.favorite,
            title: 'Favorites',
            iconColor: Colors.red,
            tapHandler: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(FavoritesScreen.routeName);
            },
          ),
           NavDrawerTile(
            icon: Icons.delete,
            title: 'Hidden',
            iconColor: Colors.grey,
            tapHandler: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(HiddenScreen.routeName);
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
