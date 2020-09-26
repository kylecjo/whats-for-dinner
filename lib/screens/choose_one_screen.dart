import 'package:flutter/material.dart';
import 'package:whats_for_dinner/models/choose_one_arguments.dart';
import 'package:whats_for_dinner/widgets/restaurant_card.dart';

class ChooseOneScreen extends StatelessWidget {
  static const routeName = '/chooseOne';

  @override
  Widget build(BuildContext context) {
    final ChooseOneArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('What\s for dinner?'),
      ),
      body: Center(child: RestaurantCard(business: args.business, cardColor: Theme.of(context).accentColor))
    );
  }
}
