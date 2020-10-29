import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/custom_list.dart';
import '../providers/auth.dart';
import '../providers/custom_lists.dart';
import '../providers/favorites.dart';
import '../models/business.dart';

class RestaurantCardHeader extends StatefulWidget {
  final Business business;

  RestaurantCardHeader({@required this.business});

  @override
  _RestaurantCardHeaderState createState() => _RestaurantCardHeaderState();
}

class _RestaurantCardHeaderState extends State<RestaurantCardHeader> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    List<String> categoryTitles = widget.business.categories
        .map((category) => category.title.toString())
        .toList();
    final favoriteProvider = Provider.of<Favorites>(context);
    final customListProvider = Provider.of<CustomLists>(context);
    final authProvider = Provider.of<Auth>(context);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                  widget.business.name,
                  style: Theme.of(context).textTheme.headline5,
                  overflow: TextOverflow.fade,
                ),
              ),
              Row(
                children: [
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      maxHeight: 30,
                      maxWidth: 30,
                    ),
                    child: PopupMenuButton<String>(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.add, color: Theme.of(context).accentIconTheme.color, size: 30),
                        onSelected: (name) {
                          int selectedListIndex = customListProvider.customLists
                              .indexWhere((element) => element.name == name);
                          if (customListProvider
                                  .customLists[selectedListIndex].businesses
                                  .singleWhere(
                                      (it) => it.id == widget.business.id,
                                      orElse: () => null) !=
                              null) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${widget.business} already in $name!'),
                              ),
                            );
                          } else {
                            customListProvider.addToCustomList(
                                customListProvider
                                    .customLists[selectedListIndex],
                                widget.business,
                                authProvider.uid);
                          }
                        },
                        itemBuilder: (BuildContext ctx) {
                          return customListProvider.customLists
                              .map((CustomList element) {
                            return PopupMenuItem<String>(
                              value: element.name,
                              child: Text(element.name),
                            );
                          }).toList();
                        }),
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (favoriteProvider.isFavorite(widget.business)) {
                        try {
                          await favoriteProvider.removeFavorite(
                              widget.business, authProvider.uid);
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('Error!'),
                                    content: Text('$e'),
                                    actions: [
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                      ),
                                    ],
                                  ));
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      } else {
                        try {
                          await favoriteProvider.addFavorite(
                              widget.business, authProvider.uid);
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                    title: Text('Error!'),
                                    content: Text('$e'),
                                    actions: [
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                      ),
                                    ],
                                  ));
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: _isLoading
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            ))
                        : favoriteProvider.isFavorite(widget.business)
                            ? Icon(Icons.star, size: 30, color: Colors.yellow[700])
                            : Icon(Icons.star_border,
                                size: 30, color: Theme.of(context).accentIconTheme.color),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              if (widget.business.price != null)
                Text(
                  '${widget.business.price} • ',
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
