import '../models/business.dart';

import 'api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  APIService(this.api);
  final API api;

  Future<List<Business>> getBusinesses(
      {String term,
      double lat,
      double long,
      int radius,
      String attributes,
      String sortBy}) async {
    final uri = api.searchUri(
      term: term,
      lat: lat,
      long: long,
      radius: radius,
      attributes: attributes,
      sortBy: sortBy,
    );

    final response = await http.get(uri.toString(),
        headers: {'Authorization': 'Bearer ${api.apiKey}'});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      Iterable jsonList = map['businesses'];
      List<Business> businesses =
          jsonList.map((model) => Business.fromJsonYelp(model)).toList();
      return businesses;
    }
    throw response;
  }
}
