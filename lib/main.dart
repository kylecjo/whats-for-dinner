import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import './data/repository.dart';
import './models/business.dart';
import './services/api.dart';
import './services/api_service.dart';
import './widgets/restaurant_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<Repository>(
      create: (_) => Repository(
        apiService: APIService(API.dev()),
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        // theme: Theme.of(context).copyWith(primaryColor: const Color(0xff41B883)),
        theme: ThemeData(
          primaryColor: const Color(0xff41B883),
          accentColor: const Color(0xffb8415b),
          // accentColor: const Color(0xffb86f41),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline5: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                bodyText2: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
                bodyText1: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                subtitle1: TextStyle(
                  fontSize: 10, 
                  color: Colors.black,
                ),
              ),
        ),

        home: MyHomePage(title: 'Nearby Restaurants'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Business> _businesses;
  final Location location = Location();
  LocationData _locationData;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  Future<void> _updateData() async {
    _locationData = await location.getLocation();
    final repository = Provider.of<Repository>(
      context,
      listen: false,
    );
    List<Business> businesses = await repository.getBusinessData(
      lat: _locationData.latitude,
      long: _locationData.longitude,
    );
    setState(() {
      _businesses = businesses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _businesses != null
            ? ListView.builder(
                itemCount: _businesses.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return RestaurantCard(_businesses[index]);
                },
              )
            : Text('Press the button to load restaurants'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateData,
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
