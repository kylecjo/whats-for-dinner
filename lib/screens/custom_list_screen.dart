import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/custom_list.dart';
import 'package:whats_for_dinner/models/screen_type.dart';
import 'package:whats_for_dinner/providers/businesses.dart';
import 'package:whats_for_dinner/widgets/choose_one_button.dart';
import 'package:whats_for_dinner/widgets/custom_list_dismissible_card.dart';

class CustomListScreen extends StatelessWidget {
  final CustomList customList;
  static const routeName = '/customList';

  CustomListScreen(this.customList);

  @override
  Widget build(BuildContext context) {
    return Consumer<Businesses>(
      builder: (ctx, data, child) => Scaffold(
        appBar: AppBar(
          title: Text(customList.name),
        ),
        body: Center(
          child: customList.businesses.length > 0
              ? ListView.builder(
                  itemCount: customList.businesses.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return CustomListDismissibleCard(
                        customList.businesses[index], customList);
                  },
                )
              : Text('No restaurants in ${customList.name} yet!'),
        ),
        floatingActionButton: ChooseOneButton(
            list: customList.businesses,
            color: Colors.yellow,
            errorText: 'No restaurants in ${customList.name} yet!',
            screenType: ScreenType.nearby),
      ),
    );
  }
}
