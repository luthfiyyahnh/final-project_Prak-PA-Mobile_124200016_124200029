import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consume_api/data/model/restaurant.dart';
import 'package:consume_api/data/model/search_restaurant.dart';
import 'package:consume_api/provider/database_provider.dart';

import '../screen/resto_detail.dart';

// UNTUK HOMEPAGE
class CardRestaurant extends StatefulWidget {
  final Restaurant? restaurant;
  const CardRestaurant({Key? key, this.restaurant}) : super(key: key);

  @override
  State<CardRestaurant> createState() => _CardRestaurantState();
}

class _CardRestaurantState extends State<CardRestaurant> {
  bool? _isFavorite;

  @override
  void initState() {
    // TODO: implement initState
    _isFavorite = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: provider.isFavorited(widget.restaurant!.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var isFavorited = snapshot.data ?? false;
            return Card(
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://restaurant-api.dicoding.dev/images/small/${widget.restaurant?.pictureId}'))),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.restaurant!.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: Colors.redAccent,
                            ),
                            Text(widget.restaurant!.city)
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: isFavorited
                      ? IconButton(
                          onPressed: () =>
                              provider.removeFavorite(widget.restaurant!.id),
                          icon: const Icon(Icons.favorite_rounded),
                          color: Colors.pinkAccent,
                        )
                      : IconButton(
                          onPressed: () =>
                              provider.addFavorite(widget.restaurant!),
                          icon: const Icon(Icons.favorite_outline_rounded),
                          color: Colors.pinkAccent,
                        ),
                  onTap: () {
                    Navigator.pushNamed(context, RestoDetails.routeName,
                        arguments: widget.restaurant!.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// UNTUK SEARCHPAGE

class CardRestaurantSearchPage extends StatelessWidget {
  final RestaurantSearch restaurant;
  const CardRestaurantSearchPage({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: provider.isFavorited(restaurant.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var isFavorited = snapshot.data ?? false;
            return Card(
              elevation: 2,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}'))),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: Colors.redAccent,
                            ),
                            Text(restaurant.city)
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: isFavorited
                      ? IconButton(
                          onPressed: () =>
                              provider.removeFavorite(restaurant.id),
                          icon: const Icon(Icons.favorite_rounded),
                          color: Colors.pinkAccent,
                        )
                      : IconButton(
                          onPressed: () =>
                              provider.addFavoriteSearch(restaurant),
                          icon: const Icon(Icons.favorite_outline_rounded),
                          color: Colors.pinkAccent,
                        ),
                  onTap: () {
                    Navigator.pushNamed(context, RestoDetails.routeName,
                        arguments: restaurant.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
