import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/custom_list.dart';
import '../models/business.dart';
import '../providers/businesses.dart';

class RestaurantCardHeader extends StatefulWidget {
  final Color color;
  final Business business;

  RestaurantCardHeader({@required this.color, @required this.business});

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
    final businesses = Provider.of<Businesses>(context);
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: widget.color,
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
                      maxHeight: 25,
                      maxWidth: 25,
                    ),
                    child: PopupMenuButton<String>(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.add, color: Colors.grey[700]),
                        onSelected: (name) {
                          int selectedListIndex = businesses.customLists.indexWhere((element) => element.name == name);
                          if (!businesses.customLists[selectedListIndex].businesses
                              .contains(widget.business)) {
                            businesses.customLists[selectedListIndex].businesses.add(widget.business);
                          } else {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${widget.business} already in $name!'),
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext ctx) {
                          return businesses.customLists.map((CustomList element) {
                            return PopupMenuItem<String>(
                              value: element.name,
                              child: Text(element.name),
                            );
                          }).toList();
                        }),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (businesses.isFavorite(widget.business)) {
                        try {
                          await businesses.removeFavorite(widget.business);
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
                          await businesses.addFavorite(widget.business);
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
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey[700],
                            ))
                        : businesses.isFavorite(widget.business)
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
