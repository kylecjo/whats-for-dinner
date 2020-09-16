import 'package:flutter/material.dart';
import '../models/business.dart';
import '../models/category.dart';

class RestaurantCard extends StatelessWidget {
  final Business business;


  RestaurantCard(this.business);

  static Map<double, String> doubleRatingToImage = {
    0.0: 'assets/images/stars_small_0.png',
    1.0: 'assets/images/stars_small_1.png',
    1.5: 'assets/images/stars_small_1_half.png',
    2.0: 'assets/images//stars_small_2.png',
    2.5: 'assets/images/stars_small_2_half.png',
    3.0: 'assets/images/stars_small_3.png',
    3.5: 'assets/images/stars_small_3_half.png',
    4.0: 'assets/images/stars_small_4.png',
    4.5: 'assets/images/stars_small_4_half.png',
    5.0: 'assets/images/stars_small_5.png',
  };

  @override
  Widget build(BuildContext context) {
    List<String> categoryTitles = business.categories.map((category) => category.title.toString()).toList();

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
                      child: 
                      business.imageUrl != '' ? Image.network(business.imageUrl) : null),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 75,
                              height: 20,
                              child: Image.asset(
                                  doubleRatingToImage[business.rating]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('${business.reviewCount} reviews' , style: Theme.of(context).textTheme.bodyText1),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if(business.price != null)
                            Text('${business.price} •',
                                style: Theme.of(context).textTheme.bodyText1),
                            Text('${categoryTitles.join(', ')}',),
                          ],
                        ),
                        Text(
                            '${business.address1}, ${business.city} ${business.state}',
                            style: Theme.of(context).textTheme.bodyText2),
                        Row(children: <Widget>[
                          business.isClosed ? Icon(Icons.close, color: Colors.red, size: 20.0,) : Icon(Icons.check, color: Colors.green, size: 20.0,),
                          Text('Open Now', style: Theme.of(context).textTheme.subtitle1),
                        ]),
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
