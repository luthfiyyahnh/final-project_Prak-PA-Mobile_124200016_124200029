import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consume_api/data/api/api_service_restaurant.dart';
import 'package:consume_api/provider/restaurant_provider.dart';
// import 'package:consume_api/provider/scheduling_provider.dart';
import 'package:consume_api/widgets/card_resto.dart';
import 'package:consume_api/widgets/platform_widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'screen/favorite_page.dart';
import 'screen/search_page.dart';
import 'screen/setting_page.dart';
import 'utils/result_state.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> listScreen = [
    const FavoriteScreen(),
    const RestoListPage(),
    const SettingPage()
  ];
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset(
          'assets/appbarBg.jpg',
          fit: BoxFit.cover,
        ),
        title: Column(
          children: const [
            Text('Restaurant', style: TextStyle(color: Colors.black)),
            Text(
              'recommendation restaurant for you !',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: listScreen[_currentIndex],
        // child: listScreen[_currentIndex],
      ),
      floatingActionButton: ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
          child: Consumer<RestaurantProvider>(builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.hasData) {
              var restaurant = state.result.restaurants;
              return FloatingActionButton(
                backgroundColor: Colors.black,
                tooltip: 'Search your favorite restaurant here',
                mini: true,
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.routeName,
                      arguments: restaurant);
                },
                child: const Icon(Icons.search),
              );
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
          })),
      bottomNavigationBar: SalomonBottomBar(
        itemPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        selectedItemColor: Colors.greenAccent,
        currentIndex: _currentIndex,
        onTap: (val) {
          setState(() {
            _currentIndex = val;
          });
        },
        items: [
          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("Favorites"),
            selectedColor: Colors.pink,
          ),

          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
    return scaffold;
  }

  List<Widget> get newMethod => listScreen;
}

class RestoListPage extends StatefulWidget {
  const RestoListPage({Key? key}) : super(key: key);

  @override
  State<RestoListPage> createState() => _RestoListPageState();
}

class _RestoListPageState extends State<RestoListPage> {
  Widget _buildList() {
    return ChangeNotifierProvider(
      create: (_) => RestaurantProvider(apiService: ApiService()),
      child: Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: Text('Wait a second . . .'));
          } else if (state.state == ResultState.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.result.restaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = state.result.restaurants[index];
                  return CardRestaurant(restaurant: restaurant);
                });
          } else if (state.state == ResultState.noData) {
            return Center(
                child: Material(
              child: Text(state.message),
            ));
          } else if (state.state == ResultState.error) {
            return Text(state.message);
          } else {
            return const Center(
              child: Material(
                child: Text(''),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(child: _buildList());
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
