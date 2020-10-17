import '../models/business.dart';
import 'package:flutter/foundation.dart';

class Businesses with ChangeNotifier {
  List<Business> _nearby = [];
  List<Business> _search = [];
  List<Business> _hot = [];
  List<Business> _top = [];

  List<Business> get nearby {
    return [..._nearby];
  }

  List<Business> get search {
    return [..._search];
  }

  List<Business> get hot {
    return [..._hot];
  }

  List<Business> get top {
    return [..._top];
  }

  void initNearby(List<Business> businesses) {
    _nearby = businesses;
    notifyListeners();
  }

  void initSearch(List<Business> businesses) {
    _search = businesses;
    notifyListeners();
  }

  void initHot(List<Business> businesses) {
    _hot = businesses;
    notifyListeners();
  }

  void initTop(List<Business> businesses) {
    _top = businesses;
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

  void addHot(Business business) {
    _hot.add(business);
    notifyListeners();
  }

  void addTop(Business business) {
    _hot.add(business);
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

  void removeHot(Business businessToRemove) {
    _hot.removeWhere((business) => business.id == businessToRemove.id);
    notifyListeners();
  }

  void removeTop(Business businessToRemove) {
    _top.removeWhere((business) => business.id == businessToRemove.id);
    notifyListeners();
  }

  Business findById(String id) {
    return _nearby.where((business) => business.id == id) as Business;
  }
}
