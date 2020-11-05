import 'package:flutter/foundation.dart';
import '../models/business.dart';

import '../services/api_service.dart';

class Repository {
  Repository({@required this.apiService});
  final APIService apiService;

  Future<List<Business>> getBusinessData({String term, double lat, double long, String location, int radius, String attributes, String sortBy, int offset}) async {
    
    return await apiService.getBusinesses(
      term: term,
      lat: lat,
      long: long,
      location: location,
      radius: radius,
      attributes: attributes,
      sortBy: sortBy,
      offset: offset,
    );
  }
}
