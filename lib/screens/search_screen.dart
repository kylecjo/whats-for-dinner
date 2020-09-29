import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/data/repository.dart';
import 'package:whats_for_dinner/models/business.dart';
import 'package:whats_for_dinner/models/screen_type.dart';
import 'package:whats_for_dinner/providers/businesses.dart';
import 'package:whats_for_dinner/widgets/choose_one_button.dart';
import 'package:whats_for_dinner/widgets/dismissible_card.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  
  final textController = TextEditingController();    
  final Location location = Location();
  LocationData _locationData;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businesses = Provider.of<Businesses>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: businesses.search.length > 0
            ? ListView.builder(
                itemCount: businesses.search.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return DismissibleCard(
                      businesses.search[index], RestaurantVisibility.visible);
                },
              )
            : TextFormField(
                controller: textController,
                decoration: InputDecoration(labelText: 'Search...'),
                textInputAction: TextInputAction.done,
                onEditingComplete: () {
                  _search();
                },
              ),
      ),
      // floatingActionButton: Builder(
      //   builder: (BuildContext ctx) {
      //     return ChooseOneButton(
      //         list: businesses.businesses,
      //         color: Color(0xffa4d1a2),
      //         errorText: 'There are no nearby restaurants!',
      //         screenType: ScreenType.nearby);
      //   },
      // ),
    );
  }

  Future<void> _search() async {
    _locationData = await location.getLocation();
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    List<Business> businesses = await repository.getBusinessData(
      term: textController.text,
      lat: _locationData.latitude,
      long: _locationData.longitude,
    );
    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.initSearch(businesses);
  }
}
