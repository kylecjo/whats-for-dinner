import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/screens/favorites_screen.dart';
import 'package:whats_for_dinner/screens/hidden_screen.dart';
import 'package:whats_for_dinner/screens/restaurants_screen.dart';

import './data/repository.dart';
import './providers/businesses.dart';
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

        initialRoute: '/',
        routes: {
          '/': (ctx) => RestaurantScreen(),
          FavoritesScreen.routeName: (ctx) => FavoritesScreen('Favorites'),
          HiddenScreen.routeName: (ctx) => HiddenScreen('Hidden'),
        }
      ),
    );
  }
}

