import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/providers/auth.dart';
import 'package:whats_for_dinner/providers/custom_lists.dart';
import 'package:whats_for_dinner/providers/favorites.dart';
import 'package:whats_for_dinner/screens/add_custom_lists_screen.dart';
import 'package:whats_for_dinner/screens/splash_screen.dart';
import 'package:whats_for_dinner/screens/tabs_screen.dart';

import './data/repository.dart';
import './providers/businesses.dart';
import './screens/choose_one_screen.dart';
import './screens/favorites_screen.dart';

import 'screens/nearby_screen.dart';
import './screens/search_screen.dart';
import './services/api.dart';
import './services/api_service.dart';
import './screens/auth_screen.dart';

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
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        Provider<Repository>(
          create: (_) => Repository(
            apiService: APIService(API.dev()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Businesses(),
        ),
        ChangeNotifierProxyProvider<Auth, Favorites>(
          create: null,
          update: (_, auth, prev) =>
              Favorites(auth.token, prev == null ? [] : prev.favorites),
        ),
        ChangeNotifierProxyProvider<Auth, CustomLists>(
          create: null,
          update: (_, auth, prev) =>
              CustomLists(auth.token, prev == null ? [] : prev.customLists),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Flutter Demo',
          // theme: Theme.of(context).copyWith(primaryColor: const Color(0xff41B883)),
          theme: ThemeData(
            fontFamily: 'RobotoMono',
            primaryColor: Colors.green,
            accentColor: Colors.white,
            // cardColor: const Color(0xffDAA99B),
            backgroundColor: Colors.grey[200],
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
                  headline4: TextStyle(
                    fontSize: 14,
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
          home: authData.isAuth
              ? TabsScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            NearbyScreen.routeName: (ctx) => NearbyScreen(),
            FavoritesScreen.routeName: (ctx) => FavoritesScreen('Favorites'),
            ChooseOneScreen.routeName: (ctx) => ChooseOneScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            AddCustomListsScreen.routeName: (ctx) =>
                AddCustomListsScreen('Custom lists'),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
