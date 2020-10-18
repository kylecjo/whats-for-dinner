import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/data/repository.dart';
import 'package:whats_for_dinner/models/business.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/providers/custom_lists.dart';
import 'package:whats_for_dinner/providers/favorites.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';

import '../providers/businesses.dart';

class NearbyScreen extends StatefulWidget {
  final String title;
  static const routeName = '/nearby';
  NearbyScreen({Key key, this.title}) : super(key: key);

  @override
  _NearbyScreen createState() => _NearbyScreen();
}

class _NearbyScreen extends State<NearbyScreen> {
  final Location location = Location();
  LocationData _locationData;
  bool _isInit = true;
  int _page = 1;
  int _resultsPerPage = 30;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<Businesses>(context);
    return Column(
      children: [
        Expanded(
          child: businessProvider.nearby.length > 0
              ? NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      _loadData();
                      setState(() {
                        isLoading = true;
                      });
                    }
                  },
                  child: ListView.builder(
                    itemCount: businessProvider.nearby.length,
                    itemBuilder: (context, int index) {
                      return RestaurantCard(
                          business: businessProvider.nearby[index],
                          cardColor: Colors.white);
                    },
                  ),
                )
              : CircularProgressIndicator(),
        ),
        Container(
            height: isLoading ? 50.0 : 0,
            color: Colors.green,
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Future<void> _loadData() async {
    _locationData = await location.getLocation();
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    List<Business> newPageNearby = await repository.getBusinessData(
        lat: _locationData.latitude,
        long: _locationData.longitude,
        radius: 2000,
        offset: _page * _resultsPerPage + 1);

    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.addNewPageNearby(newPageNearby);
    setState(() {
      _page += 1;
      isLoading = false;
    });
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
}
