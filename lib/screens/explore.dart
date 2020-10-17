import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/choose_one_arguments.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/providers/custom_lists.dart';
import 'package:whats_for_dinner/providers/favorites.dart';
import 'package:whats_for_dinner/screens/choose_one_screen.dart';
import 'package:whats_for_dinner/screens/favorites_screen.dart';
import 'package:whats_for_dinner/screens/nearby_screen.dart';

import '../data/repository.dart';
import '../models/business.dart';
import '../models/screen_type.dart';
import '../providers/businesses.dart';

class ExploreScreen extends StatefulWidget {
  final String title;
  static const routeName = '/explore';
  ExploreScreen({Key key, this.title}) : super(key: key);

  @override
  _ExploreScreen createState() => _ExploreScreen();
}

class _ExploreScreen extends State<ExploreScreen> {
  final Random rnd = new Random();
  final Location location = Location();
  LocationData _locationData;
  bool _isInit = true;

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          tabs: [
            Tab(text: 'Nearby'),
            Tab(text: 'Favorites'),
          ],
        ),
        actions: [
          GestureDetector(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Icon(Icons.shuffle)),
            onTap: () {
              final idx = DefaultTabController.of(context).index;
              if (idx == 0) {
                try {
                  int randomIndex = rnd.nextInt(businessList.nearby.length);
                  Navigator.pushNamed(
                    context,
                    ChooseOneScreen.routeName,
                    arguments: ChooseOneArguments(
                        businessList.nearby[randomIndex], ScreenType.nearby),
                  );
                } catch (_) {
                  final snackBar = SnackBar(
                    content: Text('There are no nearby restaurants!'),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              }
            },
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Icon(Icons.exit_to_app),
            ),
            onTap: (){
              Provider.of<Auth>(context, listen: false).logout();
            }
          ),
        ],
      ),
      body: TabBarView(
        children: [
          NearbyScreen(),
          FavoritesScreen('Favorites'),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Favorites>(context)
          .fetchAndSetFavorites(Provider.of<Auth>(context).uid);
      Provider.of<CustomLists>(context)
          .fetchAndSetCustomLists(Provider.of<Auth>(context).uid);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    _locationData = await location.getLocation();
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    List<Business> businesses = await repository.getBusinessData(
      lat: _locationData.latitude,
      long: _locationData.longitude,
    );
    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.initBusinesses(businesses);
  }
}
