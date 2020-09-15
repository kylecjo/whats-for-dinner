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
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  height: 200,
                  width: 200,
                  child: business.imageUrl != ''
                      ? Image.network(business.imageUrl)
                      : null,
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          business.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (business.rating != null)
                          Text(business.rating.toString()),
                        if (business.price != null) Text(business.price)
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}
