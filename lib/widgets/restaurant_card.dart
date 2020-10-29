import 'package:flutter/material.dart';
import '../widgets/restaurant_card_footer.dart';
import '../widgets/restaurant_card_header.dart';

import '../models/business.dart';

class RestaurantCard extends StatefulWidget {
  final Business business;

  RestaurantCard({@required this.business});

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.3,
      child: Card(
        child: Column(
          children: [
            RestaurantCardHeader(
              business: widget.business,
            ),
            RestaurantCardFooter(
              business: widget.business,
            ),
          ],
        ),
      ),
    );
  }
}
