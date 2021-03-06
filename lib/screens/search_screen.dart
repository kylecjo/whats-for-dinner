import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../data/repository.dart';
import '../models/business.dart';
import '../providers/businesses.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/bottom_search_sheet.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _textController = TextEditingController();
  final _modalSearchTextController = TextEditingController();
  final _modalLocationTextController =
      TextEditingController(text: 'Current Location');
  final Location _location = Location();
  FocusNode _textModalSearchNode = new FocusNode();
  FocusNode _textModalLocationNode = new FocusNode();

  LocationData _locationData;
  bool _isLoading = false;
  int _page = 1;
  int _resultsPerPage = 30;

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<Businesses>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Search'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => BottomSearchModal(
                      _textModalSearchNode,
                      _modalSearchTextController,
                      _modalLocationTextController,
                      _textModalLocationNode,
                      _search),
                );
              },
            ),
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: businessProvider.search.length > 0
                    ? NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (!_isLoading &&
                              scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                            _loadData();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          itemCount: businessProvider.search.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return RestaurantCard(
                              business: businessProvider.search[index],
                            );
                          },
                        ),
                      )
                    : Center(child: Text('Search for something')),
              ),
            ),
            Container(
              height: _isLoading ? 50.0 : 0,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    _locationData = await _location.getLocation();
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    List<Business> newPageSearch = await repository.getBusinessData(
        term: _textController.text,
        lat: _locationData.latitude,
        long: _locationData.longitude,
        radius: 30000,
        offset: _page * _resultsPerPage + 1);

    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.addNewPageSearch(newPageSearch);
    setState(() {
      _page += 1;
      _isLoading = false;
    });
  }

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
    });
    List<Business> businesses;
    _locationData = await _location.getLocation();
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    if (_modalLocationTextController.text == 'Current Location' || _modalLocationTextController.text == '' ) {
      businesses = await repository.getBusinessData(
        term: _modalSearchTextController.text,
        lat: _locationData.latitude,
        long: _locationData.longitude,
        radius: 30000,
      );
    } else{
        businesses = await repository.getBusinessData(
        term: _modalSearchTextController.text,
        location: _modalLocationTextController.text,
        radius: 30000,
      );
    }
    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.initSearch(businesses);
    setState(() {
      _isLoading = false;
    });
  }
}
