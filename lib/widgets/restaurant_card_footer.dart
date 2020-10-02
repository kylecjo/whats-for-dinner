import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/business.dart';

class RestaurantCardFooter extends StatelessWidget {
  final Business business;

  RestaurantCardFooter({this.business});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: business.imageUrl != ''
                    ? Image.network(business.imageUrl, fit: BoxFit.cover)
                    : Icon(Icons.terrain, color: Colors.grey, size: 72)),
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
                        child: Image.asset(RestaurantCardFooter
                            .doubleRatingToImage[business.rating]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: FittedBox(
                          child: Text(
                            '${business.reviewCount} reviews',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('${business.address1}',
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.fade),
                  Text('${business.city} ${business.state}',
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.fade),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width / 4.2),
                      GestureDetector(
                        onTap: () => launchURL(business.url),
                        child: Container(
                          width: 75,
                          child:
                              Image.asset('assets/images/yelp_logo_medium.png'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Map<double, String> doubleRatingToImage = {
    0.0: 'assets/images/stars_small_0.png',
    1.0: 'assets/images/stars_small_1.png',
    1.5: 'assets/images/stars_small_1_half.png',
    2.0: 'assets/images/stars_small_2.png',
    2.5: 'assets/images/stars_small_2_half.png',
    3.0: 'assets/images/stars_small_3.png',
    3.5: 'assets/images/stars_small_3_half.png',
    4.0: 'assets/images/stars_small_4.png',
    4.5: 'assets/images/stars_small_4_half.png',
    5.0: 'assets/images/stars_small_5.png',
  };

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
