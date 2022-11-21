import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consume_api/data/api/api_service_restaurant.dart';
import 'package:consume_api/provider/restaurant_provider.dart';
import 'package:consume_api/widgets/card_resto.dart';

import '../provider/restaurant_search_provider.dart';
import '../utils/result_state.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search_page';

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool? isSearch;
  TextEditingController searchEditingController = TextEditingController();
  String? searchRestoName;

  @override
  void initState() {
    // TODO: implement initState
    searchRestoName = '';
    isSearch = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 60),
                child: const Text('Search',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 36))),

            // SEARCH FIELD
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(20)),
                  child: Consumer<RestaurantSearchProvider>(
                    builder: (context, state, _) {
                      return TextFormField(
                          textCapitalization: TextCapitalization.words,
                          controller: searchEditingController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(left: 15, top: 3),
                            border: InputBorder.none,
                            hintText: 'search . . .',
                            suffixIcon: isSearch != true
                                ? const Icon(Icons.search)
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        searchEditingController.value =
                                            TextEditingValue.empty;
                                      });
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                          onChanged: (val) {
                            if (val.isNotEmpty) {
                              setState(() {
                                searchRestoName = val;
                                isSearch = true;
                              });
                            } else {
                              setState(() {
                                isSearch = false;
                              });
                            }
                            state.findRestaurant(searchRestoName!);
                          });
                    },
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('batal'))
              ],
            ),

            // item from consumer
            searchRestoName!.isEmpty
                ? const Center(
                    child: Text(
                    'Looking for restaurant ?',
                    style: TextStyle(fontSize: 18),
                  ))
                : ChangeNotifierProvider(
                    create: (_) => RestaurantProvider(apiService: ApiService()),
                    child: Consumer<RestaurantSearchProvider>(
                      builder: (context, state, _) {
                        if (state.state == ResultState.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state.state == ResultState.hasData) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: state.result.restaurants.length,
                              itemBuilder: (BuildContext context, int index) {
                                var restaurant =
                                    state.result.restaurants[index];
                                if (restaurant.name ==
                                        searchEditingController.text ||
                                    restaurant.name.startsWith(
                                        searchEditingController.text) ||
                                    restaurant.name[0].toLowerCase() ==
                                        searchEditingController.text[0]) {
                                  return CardRestaurantSearchPage(
                                      restaurant: restaurant);
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          );
                        } else if (state.state == ResultState.noData) {
                          return Center(child: Text(state.message));
                        } else if (state.state == ResultState.error) {
                          return Center(child: Text(state.message));
                        } else {
                          return const Text('');
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
