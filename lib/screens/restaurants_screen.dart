import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../data/repository.dart';
import '../models/business.dart';
import '../models/screen_type.dart';
import '../providers/businesses.dart';
import '../widgets/choose_one_button.dart';
import '../widgets/dismissible_card.dart';
import '../widgets/nav_drawer.dart';

class RestaurantScreen extends StatefulWidget {
  final String title;

  RestaurantScreen({Key key, this.title}) : super(key: key);

  @override
  _RestaurantScreen createState() => _RestaurantScreen();
}

class _RestaurantScreen extends State<RestaurantScreen> {
  final Location location = Location();
  LocationData _locationData;
  bool _isInit =  true;

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby restaurants'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: businessList.businesses.length > 0
            ? ListView.builder(
                itemCount: businessList.businesses.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return DismissibleCard(businessList.businesses[index],
                      RestaurantVisibility.visible);
                },
              )
            : CircularProgressIndicator(),
      ),
      drawer: NavDrawer(),
      floatingActionButton: Builder(
        builder: (BuildContext ctx) {
          return ChooseOneButton(
            list: businessList.businesses,
            color: Color(0xffa4d1a2),
            errorText: 'There are no nearby restaurants!',
            screenType: ScreenType.nearby,
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      Provider.of<Businesses>(context).fetchAndSetFavorites();
      Provider.of<Businesses>(context).fetchAndSetCustomLists();
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
