import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';

import '../data/repository.dart';
import '../models/business.dart';
import '../providers/businesses.dart';


class HotNewScreen extends StatefulWidget {
  @override
  _HotNewScreenState createState() => _HotNewScreenState();
}

class _HotNewScreenState extends State<HotNewScreen> {
  final Location location = Location();
  LocationData _locationData;

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<Businesses>(context);
    return Center(
      child: businessProvider.nearby.length > 0
          ? ListView.builder(
              itemCount: businessProvider.hot.length,
              itemBuilder: (context, int index) {
                return RestaurantCard(
                    business: businessProvider.hot[index],
                    cardColor: Colors.white);
              },
            )
          : CircularProgressIndicator(),
    );
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
      attributes: 'hot_and_new',
      radius: 40000,
    );
    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.initHot(businesses);
  }
}
