import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/choose_one_arguments.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/screens/choose_one_screen.dart';
import 'package:whats_for_dinner/screens/hot&new_screen.dart';
import 'package:whats_for_dinner/screens/nearby_screen.dart';
import 'package:whats_for_dinner/screens/top_rated_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<Businesses>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Explore'),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          tabs: [
            Tab(text: 'Nearby'),
            Tab(text: 'Hot & New'),
            Tab(text: 'Top Rated')
          ],
        ),
        actions: [
          GestureDetector(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Icon(Icons.shuffle)),
            onTap: () {
              final idx = DefaultTabController.of(context).index;
              switch (idx) {
                case 0:
                  chooseOne(businessProvider.nearby,
                      'There are no nearby businesses!');
                  break;
                case 1:
                  chooseOne(
                      businessProvider.hot, 'There are no new restaurants!');
                  break;
                case 2:
                  chooseOne(
                      businessProvider.top, 'There are no top restaurants!');
                  break;
                default:
              }
            },
          ),
          GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Icon(Icons.exit_to_app),
              ),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
              }),
        ],
      ),
      body: TabBarView(
        children: [
          NearbyScreen(),
          HotNewScreen(),
          TopRatedScreen(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      _locationData = await location.getLocation();
      final repository = Provider.of<Repository>(
        context,
        listen: false,
      );
      List<Business> nearby = await repository.getBusinessData(
        lat: _locationData.latitude,
        long: _locationData.longitude,
        radius: 2000,
      );
      final businessList = Provider.of<Businesses>(context, listen: false);
      businessList.initNearby(nearby);

      // List<Business> hotnew = await repository.getBusinessData(
      //   lat: _locationData.latitude,
      //   long: _locationData.longitude,
      //   attributes: 'hot_and_new',
      //   radius: 40000,
      // );
      // businessList.initHot(hotnew);

      // List<Business> top = await repository.getBusinessData(
      //   lat: _locationData.latitude,
      //   long: _locationData.longitude,
      //   radius: 40000,
      //   sortBy: 'rating',
      // );
      // businessList.initTop(top);
    } catch (e) {
      throw e;
    }
  }

  void chooseOne(List<Business> businesses, String errorText) {
    try {
      int randomIndex = rnd.nextInt(businesses.length);
      Navigator.pushNamed(
        context,
        ChooseOneScreen.routeName,
        arguments:
            ChooseOneArguments(businesses[randomIndex], ScreenType.nearby),
      );
    } catch (_) {
      final snackBar = SnackBar(
        content: Text(errorText),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
