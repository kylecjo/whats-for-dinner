// import 'package:flutter/material.dart';
// import '../screens/favorites_screen.dart';
// import '../screens/restaurants_screen.dart';
// import '../widgets/choose_one_button.dart';


// class TabsScreen extends StatefulWidget {
//   @override
//   _TabsScreenState createState() => _TabsScreenState();
// }

// class _TabsScreenState extends State<TabsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Restaurants'),
//           bottom: TabBar(
//             tabs: [
//               Tab(icon: Icon(Icons.near_me), text: 'Nearby'),
//               Tab(icon: Icon(Icons.category), text: 'Favorites'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             RestaurantScreen(title: 'Nearby Restaurants'),
//             FavoritesScreen('Favorites'),
//           ],
//         ),
//         floatingActionButton: Builder(
//           builder: (BuildContext ctx) {
//             return ChooseOneButton();
//           },
//         ),
//       ),
//     );
//   }
// }
