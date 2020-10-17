import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';

import '../providers/businesses.dart';

class TopRatedScreen extends StatefulWidget {
  @override
  _TopRatedScreenState createState() => _TopRatedScreenState();
}

class _TopRatedScreenState extends State<TopRatedScreen> {
final Location location = Location();

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<Businesses>(context);
    return Center(
      child: businessProvider.nearby.length > 0
          ? ListView.builder(
              itemCount: businessProvider.top.length,
              itemBuilder: (BuildContext ctx, int index) {
                return RestaurantCard(
                    business: businessProvider.top[index],
                    cardColor: Colors.white);
              },
            )
          : CircularProgressIndicator(),
    );
  }

}
