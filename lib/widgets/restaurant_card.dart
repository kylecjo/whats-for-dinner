import 'package:flutter/material.dart';
import '../widgets/restaurant_card_footer.dart';
import '../widgets/restaurant_card_header.dart';

import '../models/business.dart';

class RestaurantCard extends StatefulWidget {
  final Business business;
  final Color cardColor;

  RestaurantCard({@required this.business, @required this.cardColor});

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.3,
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            RestaurantCardHeader(
              color: widget.cardColor,
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
