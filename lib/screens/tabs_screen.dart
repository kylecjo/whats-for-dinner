import 'package:flutter/material.dart';

import '../screens/add_custom_lists_screen.dart';
import '../screens/explore.dart';
import '../screens/search_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {'page': DefaultTabController(length: 3, child:  ExploreScreen())},
    {'page': SearchScreen()},
    {'page': AddCustomListsScreen()},
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          backgroundColor: Theme.of(context).cardColor,
          unselectedItemColor: Theme.of(context).textTheme.bodyText2.color,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title: Text('Explore'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Lists'),
            ),
          ],
        ),
    );
  }
}
