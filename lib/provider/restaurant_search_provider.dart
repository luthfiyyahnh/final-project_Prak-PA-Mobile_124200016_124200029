import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/api/api_service_restaurant.dart';
import 'package:consume_api/data/model/search_restaurant.dart';
import '../utils/result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService}) {
    findRestaurant(namaResto);
  }
  final String _namaResto = '';
  String get namaResto => _namaResto;

  late SearchResto _restoResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  SearchResto get result => _restoResult;
  ResultState get state => _state;

  Future<dynamic> findRestaurant(String namaResto) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.findResto(namaResto);
      if (result.restaurants.isEmpty) {
        debugPrint('tidak ada data');
        _state = ResultState.noData;
        return _message = 'Empty Data';
      } else {
        debugPrint('ada data : $namaResto');
        _state = ResultState.hasData;
        notifyListeners();
        return _restoResult = result;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      print(e);
      return _message = 'Cannot load restaurant';
    }
  }
}
