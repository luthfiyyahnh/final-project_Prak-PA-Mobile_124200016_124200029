import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:consume_api/data/model/detail_restaurant.dart';
import 'package:consume_api/data/model/restaurant.dart';
import 'package:consume_api/data/model/search_restaurant.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _list = 'list';
  static const String _detail = 'detail/';
  static const String _search = 'search?q=';

  Future<RestoData> restoHeadline() async {
    final response = await http.get(Uri.parse('$_baseUrl$_list'));

    if (response.statusCode == 200) {
      return RestoData.fromJson(json.decode(response.body));
    } else {
      throw 'Failed to Load Data';
    }
  }

  Future<DetailResto> restoDetail(id) async {
    final response = await http.get(Uri.parse('$_baseUrl$_detail$id'));
    if (response.statusCode == 200) {
      return DetailResto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to Load Detail');
    }
  }

  Future<SearchResto> findResto(namaResto) async {
    final response = await http.get(Uri.parse('$_baseUrl$_search$namaResto'));
    if (response.statusCode == 200) {
      return SearchResto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Cannot find restaurant');
    }
  }
}
