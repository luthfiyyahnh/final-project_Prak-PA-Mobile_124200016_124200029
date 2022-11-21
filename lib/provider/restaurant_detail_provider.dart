import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:consume_api/data/api/api_service_restaurant.dart';
import 'package:consume_api/data/model/detail_restaurant.dart';
import '../utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String idResto;

  RestaurantDetailProvider({required this.apiService, required this.idResto}) {
    fetchDetail(idResto);
  }

  late DetailResto _restoResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  DetailResto get result => _restoResult;
  ResultState get state => _state;

  Future<dynamic> fetchDetail(String idResto) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final result = await apiService.restoDetail(idResto);
      if (result.restaurant.id.isEmpty) {
        _state = ResultState.noData;
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restoResult = result;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    }
  }
}
