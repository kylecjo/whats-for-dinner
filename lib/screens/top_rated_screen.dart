import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/data/repository.dart';
import 'package:whats_for_dinner/models/business.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';

import '../providers/businesses.dart';

class TopRatedScreen extends StatefulWidget {
  @override
  _TopRatedScreenState createState() => _TopRatedScreenState();
}

class _TopRatedScreenState extends State<TopRatedScreen> {
  final Location location = Location();
  LocationData _locationData;
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
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: businessProvider.top.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return RestaurantCard(
                          business: businessProvider.top[index],
                          cardColor: Colors.white);
                    },
                  ),
                )
              : CircularProgressIndicator(),
        ),
        Container(
          height: isLoading ? 50.0 : 0,
          color:  Theme.of(context).primaryColor,
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
    List<Business> newPageTop = await repository.getBusinessData(
        lat: _locationData.latitude,
        long: _locationData.longitude,
        radius: 2000,
        offset: _page * _resultsPerPage + 1);

    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.addNewPageTop(newPageTop);
    setState(() {
      _page += 1;
      isLoading = false;
    });
  }
}
