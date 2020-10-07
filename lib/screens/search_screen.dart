import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/widgets/search_dismissible_card.dart';

import '../data/repository.dart';
import '../models/business.dart';
import '../models/screen_type.dart';
import '../providers/businesses.dart';
import '../widgets/choose_one_button.dart';
import '../widgets/nav_drawer.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();
  final Location _location = Location();
  LocationData _locationData;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businesses = Provider.of<Businesses>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: TextFormField(
            controller: _textController,
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Colors.black),
              fillColor: Theme.of(context).backgroundColor,
              filled: true,
            ),
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              _search();
              FocusScope.of(context).unfocus();
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: businesses.search.length > 0
                          ? ListView.builder(
                              itemCount: businesses.search.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return SearchDismissibleCard(
                                  businesses.search[index],
                                );
                              },
                            )
                          : Center(child: Text('Search for something')),
                    ),
                  ],
                ),
              ),
        drawer: NavDrawer(),
        floatingActionButton: Builder(
          builder: (BuildContext ctx) {
            return ChooseOneButton(
                list: businesses.search,
                color: Color(0xffa4d1a2),
                errorText: 'There are no nearby restaurants!',
                screenType: ScreenType.search);
          },
        ),
      ),
    );
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
    });
    _locationData = await _location.getLocation();
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    List<Business> businesses = await repository.getBusinessData(
      term: _textController.text,
      lat: _locationData.latitude,
      long: _locationData.longitude,
    );
    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.initSearch(businesses);
    setState(() {
      _isLoading = false;
    });
  }
}
