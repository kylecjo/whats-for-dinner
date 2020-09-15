import 'package:flutter/foundation.dart';
import 'api_keys.dart';

class API{
  API({@required this.apiKey});
  final String apiKey;

  static const lat = 53.450199;
  static const long = -113.398010;

  factory API.dev() => API(apiKey: APIKeys.yelpAuth);

  static final String host = 'api.yelp.com';

  // Uri searchUri(Map<String, dynamic> queries) => Uri.https(
  //   host, '/search', queries
  // );

  Uri searchUri(){
    Uri uri = Uri.https(host, '/v3/businesses/search', { 'latitude': lat.toString(), 'longitude' : long.toString() });

    return uri;  
  }

}