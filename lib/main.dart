import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import './providers/businesses.dart';
import './widgets/dismissible_card.dart';

import './data/repository.dart';
import './models/business.dart';
import './services/api.dart';
import './services/api_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repository>(
          create: (_) => Repository(
            apiService: APIService(API.dev()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Businesses(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        // theme: Theme.of(context).copyWith(primaryColor: const Color(0xff41B883)),
        theme: ThemeData(
          fontFamily: 'RobotoMono',
          primaryColor: const Color(0xff8FADC9),
          accentColor: const Color(0xffDAA99B),
          // cardColor: const Color(0xffDAA99B),
          backgroundColor: Colors.white,
          dividerColor: const Color(0xffDAA99B),
          // accentColor: const Color(0xffb86f41),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                headline5: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                bodyText2: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[700],
                ),
                bodyText1: TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
                subtitle1: TextStyle(
                  fontSize: 9,
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
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Location location = Location();
  LocationData _locationData;
  final Random rnd = new Random();
  bool _initState = true;

  @override
  Widget build(BuildContext context) {
    final businessList = Provider.of<Businesses>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: businessList.businesses != null
              ? RefreshIndicator(
                  child: ListView.builder(
                    itemCount: businessList.businesses.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return DismissibleCard(index);
                    },
                  ),
                  onRefresh: _updateData,
                )
              : Text('Press the button to load restaurants'),
        ),
        floatingActionButton: Builder(builder: (BuildContext ctx) {
          return FloatingActionButton(
            onPressed: () {
              int randomIndex = rnd.nextInt(businessList.favorites.length);
              final snackBar = SnackBar(
                content: businessList.favorites.length > 0
                    ? Text(businessList.favorites[randomIndex].toString())
                    : Text('You have no favorites!'),
              );
              Scaffold.of(ctx).showSnackBar(snackBar);
            },
            child: Icon(Icons.shuffle),
          );
        }) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      _updateData();
    }
    _initState = false;
    super.didChangeDependencies();
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
    final businessList = Provider.of<Businesses>(context, listen: false);
    businessList.initBusinesses(businesses);
  }
}
