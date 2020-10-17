import '../models/business.dart';
import 'package:flutter/foundation.dart';

class Businesses with ChangeNotifier {
  List<Business> _nearby = [];
  List<Business> _search = [];

  List<Business> get nearby {
    return [..._nearby];
  }

  List<Business> get search {
    return [..._search];
  }

  void initBusinesses(List<Business> businesses) {
    _nearby = businesses;
    notifyListeners();
  }

  void initSearch(List<Business> businesses) {
    _search = businesses;
    notifyListeners();
  }

  void addBusiness(Business business) {
    _nearby.add(business);
    notifyListeners();
  }

  void addSearch(Business business) {
    _search.add(business);
    notifyListeners();
  }

  void removeSearch(Business business) {
    _search.removeWhere((element) => element.id == business.id);
    notifyListeners();
  }

  void removeBusiness(Business businessToRemove) {
    _nearby.removeWhere((business) => business.id == businessToRemove.id);
    notifyListeners();
  }

  Business findById(String id) {
    return _nearby.where((business) => business.id == id) as Business;
  }

}
