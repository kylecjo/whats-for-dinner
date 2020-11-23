import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_dinner/models/choose_one_arguments.dart';
import 'package:whats_for_dinner/screens/settings_screen.dart';

import './data/repository.dart';
import './providers/auth.dart';
import './providers/businesses.dart';
import './providers/custom_lists.dart';
import './providers/favorites.dart';
import './screens/auth_screen.dart';
import './screens/choose_one_screen.dart';
import './screens/favorites_screen.dart';
import './screens/nearby_screen.dart';
import './screens/search_screen.dart';
import './screens/splash_screen.dart';
import './screens/tabs_screen.dart';
import './services/api.dart';
import './services/api_service.dart';

void main() async{
 
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GlobalConfiguration().loadFromAsset("app_settings");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
          darkTheme: ThemeData(
            fontFamily: 'RobotoMono',
            primaryColor: Color(0xff121212),
            accentColor: Colors.white,
            cardColor: Color(0xff212121),
            scaffoldBackgroundColor: Colors.grey[200],
            backgroundColor: Color(0xff121212),
            dividerColor: const Color(0xffDAA99B),
            // accentColor: const Color(0xffb86f41),
            textTheme: ThemeData.dark().textTheme.copyWith(
                  headline6: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  headline5: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  subtitle1: TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                  ),
                ),
            primaryIconTheme: IconThemeData(
              color: Colors.white,
            ),
            accentIconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          theme: ThemeData(
            fontFamily: 'RobotoMono',
            primaryColor: Colors.deepOrange[500],
            accentColor: Colors.white,
            cardColor: Colors.white,
            scaffoldBackgroundColor: Colors.grey[200],
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
            primaryIconTheme: IconThemeData(
              color: Colors.white,
            ),
            accentIconTheme: IconThemeData(
              color: Colors.grey[700],
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
            SearchScreen.routeName: (ctx) => SearchScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == ChooseOneScreen.routeName) {
              final ChooseOneArguments args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return ChooseOneScreen(
                    args.businesses,
                  );
                },
              );
            }
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness =
        WidgetsBinding.instance.window.platformBrightness;
    //inform listeners and rebuild widget tree
  }
}
