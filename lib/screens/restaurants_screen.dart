
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../data/repository.dart';
import '../models/business.dart';
import '../providers/businesses.dart';
import '../widgets/dismissible_card.dart';


class RestaurantScreen extends StatefulWidget {
  final String title;

  RestaurantScreen({Key key, this.title}) : super(key: key);

  @override
  _RestaurantScreen createState() => _RestaurantScreen();
}

class _RestaurantScreen extends State<RestaurantScreen> {
  final Location location = Location();
  LocationData _locationData;
  final Random _rnd = new Random();
  bool _initState = true;

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: businessList.businesses != null
              ? RefreshIndicator(
                  child: ListView.builder(
                    itemCount: businessList.businesses.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return DismissibleCard(index);
                    },
                  ),
                  onRefresh: _updateData,
                )
              : Text('Press the button to load restaurants'),
        ),
        floatingActionButton: Builder(builder: (BuildContext ctx) {
          return FloatingActionButton(
            onPressed: () {
              int randomIndex = _rnd.nextInt(businessList.favorites.length);
              final snackBar = SnackBar(
                content: businessList.favorites.length > 0
                    ? Text(businessList.favorites[randomIndex].toString())
                    : Text('You have no favorites!'),
              );
              Scaffold.of(ctx).showSnackBar(snackBar);
            },
            child: Icon(Icons.shuffle),
          );
        }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      _updateData();
    }
    _initState = false;
    super.didChangeDependencies();
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
