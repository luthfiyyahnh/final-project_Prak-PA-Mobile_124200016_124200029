import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consume_api/provider/database_provider.dart';
import 'package:consume_api/widgets/card_resto.dart';

import '../utils/result_state.dart';
import '../widgets/platform_widget.dart';

class FavoriteScreen extends StatelessWidget {
  static const String favoritesTitle = 'Favorites';

  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PlatformWidget(
            androidBuilder: _buildAndroid, iosBuilder: _buildIos));
  }

  Widget _buildAndroid(BuildContext context) {
    return _buildList();
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(child: _buildList());
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      if (provider.state == ResultState.hasData) {
        return ListView.builder(
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.favorites[index]);
            });
      } else {
        return Center(
          child: Text(provider.message),
        );
      }
    });
  }
}
