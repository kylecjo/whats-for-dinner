import 'package:flutter/foundation.dart';
import 'api_keys.dart';

class API {
  API({@required this.apiKey});
  final String apiKey;

  factory API.dev() => API(apiKey: APIKeys.yelpAuth);

  static final String host = 'api.yelp.com';

  // Uri searchUri(Map<String, dynamic> queries) => Uri.https(
  //   host, '/search', queries
  // );

  Uri searchUri({double lat, double long}) {
    Uri uri = Uri.https(host, '/v3/businesses/search', {
      'latitude': lat.toString(),
      'longitude': long.toString(),
      'radius': '2000',
      'limit': '30',
      'categories': 'restaurants'
    });
    return uri;
  }
}
