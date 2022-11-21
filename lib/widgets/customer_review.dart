import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consume_api/provider/restaurant_detail_provider.dart';
import '../utils/result_state.dart';

class CustomerReview extends StatelessWidget {
  const CustomerReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(builder: (context, state, _) {
      if (state.state == ResultState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.state == ResultState.hasData) {
        var restaurant = state.result;
        return Column(children: [
          const Text('Customer Review'),
          ListView.builder(
              itemCount: restaurant.restaurant.customerReviews.length,
              itemBuilder: (BuildContext context, int index) {
                return Expanded(
                    child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(restaurant.restaurant.customerReviews[index].name),
                        Text(restaurant.restaurant.customerReviews[index].date)
                      ]),
                  Text(
                      "\"${restaurant.restaurant.customerReviews[index].review}\"")
                ]));
              }),
        ]);
      } else if (state.state == ResultState.noData) {
        return Center(
          child: Material(
            child: Text(state.message),
          ),
        );
      } else if (state.state == ResultState.error) {
        return Center(
          child: Material(
            child: Text(state.message),
          ),
        );
      } else {
        return const Center(
          child: Material(
            child: Text(''),
          ),
        );
      }
    });
  }
}
