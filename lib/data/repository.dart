
import 'package:flutter/foundation.dart';

import '../services/api_service.dart';

class Repository{
  Repository({@required this.apiService});
  final APIService apiService;

  Future<String> getBusinessData() async{
    return await apiService.getBusinesses();
  }

}