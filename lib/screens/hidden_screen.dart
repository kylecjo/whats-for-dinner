import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/businesses.dart';
import '../widgets/dismissible_card.dart';
import '../widgets/nav_drawer.dart';

class HiddenScreen extends StatelessWidget {
  final String title;
  static const routeName = '/hidden';

  HiddenScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final businesses = Provider.of<Businesses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: businesses.hidden.length > 0
            ? ListView.builder(
                itemCount: businesses.hidden.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return DismissibleCard(businesses.hidden[index], RestaurantVisibility.hidden);
                },
              )
            : Text('No hidden restaurants!'),
      ),
      drawer: NavDrawer(),
    );
  }
}
