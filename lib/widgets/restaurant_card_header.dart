import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/business.dart';
import '../providers/businesses.dart';

class RestaurantCardHeader extends StatelessWidget {
  final Color color;
  final Business business;

  RestaurantCardHeader({@required this.color, @required this.business});

  @override
  Widget build(BuildContext context) {
    List<String> categoryTitles = business.categories
        .map((category) => category.title.toString())
        .toList();
    final businesses = Provider.of<Businesses>(context);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0))),
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
              Row(
                children: [
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      maxHeight: 25,
                      maxWidth: 25,
                    ),
                    child: PopupMenuButton<String>(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.add, color: Colors.grey[700]),
                        onSelected: (key) {
                          businesses.customLists[key].add(business);
                        },
                        itemBuilder: (BuildContext ctx) {
                          return businesses.customLists.keys.map((String key) {
                            return PopupMenuItem<String>(
                              value: key,
                              child: Text(key),
                            );
                          }).toList();
                        }),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (businesses.favorites.contains(business)) {
                        businesses.removeFavorite(business);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$business unfavorited!'),
                          ),
                        );
                      } else {
                        businesses.addFavorite(business);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$business favorited!'),
                          ),
                        );
                      }
                    },
                    child: businesses.isFavorite(business)
                        ? Icon(Icons.star, size: 20, color: Colors.yellow)
                        : Icon(Icons.star_border,
                            size: 20, color: Colors.grey[700]),
                  ),
                ],
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
    );
  }
}
