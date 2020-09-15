import 'package:flutter/material.dart';
import '../models/business.dart';

class RestaurantCard extends StatelessWidget {
  final Business business;

  RestaurantCard(this.business);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 225,
      width: double.infinity,
      child: Card(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              left: 5.0,
            ),
            child: Row(
              children: [
                Text(
                  business.name,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 5.0,
            ),
            height: 150,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  width: 180,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(business.imageUrl)),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${business.rating} ${business.reviewCount} reviews', style: Theme.of(context).textTheme.bodyText1),
                        Text('${business.price}', style: Theme.of(context).textTheme.bodyText1),
                        Text(
                            '${business.address1}, ${business.city} ${business.state}',
                            style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
