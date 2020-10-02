import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/screen_type.dart';
import 'package:whats_for_dinner/providers/businesses.dart';
import 'package:whats_for_dinner/widgets/choose_one_button.dart';
import 'package:whats_for_dinner/widgets/dismissible_card.dart';

class CustomListScreen extends StatelessWidget {
  final String title;
  static const routeName = '/customList';

  CustomListScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final businesses = Provider.of<Businesses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: businesses.customLists[title].length > 0
            ? ListView.builder(
                itemCount: businesses.customLists[title].length,
                itemBuilder: (BuildContext ctx, int index) {
                  return DismissibleCard(businesses.customLists[title][index],
                      RestaurantVisibility.visible);
                },
              )
            : Text('No restaurants in $title yet!'),
      ),
      floatingActionButton: ChooseOneButton(
          list: businesses.customLists[title],
          color: Colors.yellow,
          errorText: 'ErrorText',
          screenType: ScreenType.nearby),
    );
  }
}
