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

  Uri searchUri({String term, double lat, double long, int radius, String attributes, String sortBy, int offset}) {
    Uri uri = Uri.https(host, '/v3/businesses/search', {
      'term': term,
      'latitude': lat.toString(),
      'longitude': long.toString(),
      'radius': radius != null ? radius.toString() : '2000',
      'limit': '30',
      'attributes': attributes,
      'sortBy': sortBy,
      'offset': offset != null ? offset.toString() : '0',
    });
    return uri;
  }
}
