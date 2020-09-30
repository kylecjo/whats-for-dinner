import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_for_dinner/providers/businesses.dart';

import '../models/business.dart';

class RestaurantCard extends StatelessWidget {
  final Business business;
  final Color cardColor;

  RestaurantCard({@required this.business, @required this.cardColor});

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

  @override
  Widget build(BuildContext context) {
    List<String> categoryTitles = business.categories
        .map((category) => category.title.toString())
        .toList();
    final businesses = Provider.of<Businesses>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: MediaQuery.of(context).size.height / 3,
      child: Card(
          elevation: 2,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            business.name,
                            style: Theme.of(context).textTheme.headline5,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            if(businesses.favorites.contains(business)){
                              businesses.removeFavorite(business);
                            } else{
                              businesses.addFavorite(business);
                            }
                          },
                          child: businesses.isFavorite(business)
                              ? Icon(Icons.star, size: 20, color: Colors.yellow)
                              : Icon(Icons.star_border,
                                  size: 20, color: Colors.grey[700]),
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        if (business.price != null)
                          Text(
                            '${business.price} • ',
                          ),
                        Flexible(
                          child: Text(
                            '${categoryTitles.join(', ')}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
                          child: business.imageUrl != ''
                              ? Image.network(business.imageUrl,
                                  fit: BoxFit.cover)
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
                                  child: Image.asset(
                                      doubleRatingToImage[business.rating]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: FittedBox(
                                    child: Text(
                                      '${business.reviewCount} reviews',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
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
                                SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        4.2),
                                GestureDetector(
                                  onTap: () => launchURL(business.url),
                                  child: Container(
                                    width: 75,
                                    child: Image.asset(
                                        'assets/images/yelp_logo_medium.png'),
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
              ),
            ],
          )),
    );
  }
}
