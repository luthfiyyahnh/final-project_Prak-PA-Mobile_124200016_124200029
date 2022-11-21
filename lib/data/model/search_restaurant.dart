import 'dart:convert';

SearchResto searchRestoFromJson(String str) => SearchResto.fromJson(json.decode(str));

String searchRestoToJson(SearchResto data) => json.encode(data.toJson());

class SearchResto {
    SearchResto({
        required this.error,
        required this.founded,
        required this.restaurants,
    });

    final bool error;
    final int founded;
    final List<RestaurantSearch> restaurants;

    factory SearchResto.fromJson(Map<String, dynamic> json) => SearchResto(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantSearch>.from(json["restaurants"].map((x) => RestaurantSearch.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
}

class RestaurantSearch {
    RestaurantSearch({
        required this.id,
        required this.name,
        required this.description,
        required this.pictureId,
        required this.city,
        required this.rating,
    });

    final String id;
    final String name;
    final String description;
    final String pictureId;
    final String city;
    final double rating;

    factory RestaurantSearch.fromJson(Map<String, dynamic> json) => RestaurantSearch(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
    };
}
