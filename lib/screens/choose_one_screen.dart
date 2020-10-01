import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/choose_one_arguments.dart';
import '../models/screen_type.dart';
import '../providers/businesses.dart';
import '../widgets/restaurant_card.dart';

class ChooseOneScreen extends StatefulWidget {
  static const routeName = '/chooseOne';

  @override
  _ChooseOneScreenState createState() => _ChooseOneScreenState();
}

class _ChooseOneScreenState extends State<ChooseOneScreen>
    with SingleTickerProviderStateMixin {
  final Random _rnd = new Random();
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this)
      ..repeat(reverse: true);
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.8,
          curve: Curves.bounceIn,
        ),
      ),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.82,
        1.0,
        curve: Curves.easeIn,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChooseOneArguments args = ModalRoute.of(context).settings.arguments;
    final businesses = Provider.of<Businesses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('What\'s for Dinner?'),
      ),
      body: Column(
        children: [
          SlideTransition(
            position: _offsetAnimation,
            child: RestaurantCard(
                business: args.business,
                cardColor: Theme.of(context).accentColor),
          ),
          SizedBox(height: 10),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      launch("tel://${args.business.phone}");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.phone),
                        Text(
                          'Call Restaurant',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (args.screenType == ScreenType.nearby) {
                        int randomIndex =
                            _rnd.nextInt(businesses.businesses.length);
                        Navigator.pushReplacementNamed(
                          context,
                          ChooseOneScreen.routeName,
                          arguments: ChooseOneArguments(
                              businesses.businesses[randomIndex],
                              ScreenType.nearby),
                        );
                      } else if (args.screenType == ScreenType.search) {
                        int randomIndex =
                            _rnd.nextInt(businesses.search.length);
                        Navigator.pushReplacementNamed(
                          context,
                          ChooseOneScreen.routeName,
                          arguments: ChooseOneArguments(
                              businesses.search[randomIndex],
                              ScreenType.search),
                        );
                      } else {
                        int randomIndex =
                            _rnd.nextInt(businesses.favorites.length);
                        Navigator.pushReplacementNamed(
                          context,
                          ChooseOneScreen.routeName,
                          arguments: ChooseOneArguments(
                              businesses.favorites[randomIndex],
                              ScreenType.favorites),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.shuffle),
                        Text(
                          'Reroll Restaurant',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
