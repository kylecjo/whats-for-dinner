import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';

import '../providers/businesses.dart';


class HotNewScreen extends StatefulWidget {
  @override
  _HotNewScreenState createState() => _HotNewScreenState();
}

class _HotNewScreenState extends State<HotNewScreen> {
  final Location location = Location();

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

}
