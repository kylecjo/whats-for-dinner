import 'package:flutter/material.dart';
import '../models/business.dart';

class RestaurantCard extends StatelessWidget {
  final Business business;

  RestaurantCard(this.business);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 200,
      width: double.infinity,
      child: Card(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: 200,
            width: 200,
            child: business.imageUrl != ''
                ? Image.network(business.imageUrl)
                : null,
          ),
          Flexible(
            child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(business.name, overflow: TextOverflow.ellipsis),
                    if (business.rating != null)
                      Text(business.rating.toString()),
                    if (business.price != null) Text(business.price)
                  ],
                )),
          )
        ],
      )),
    );
  }
}
