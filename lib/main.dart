// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:consume_api/common/navigation.dart';
import 'package:consume_api/data/api/api_service_restaurant.dart';
import 'package:consume_api/home_page.dart';
import 'package:consume_api/provider/database_provider.dart';
import 'package:consume_api/provider/restaurant_search_provider.dart';
// import 'package:consume_api/screen/setting_page.dart';
import 'package:consume_api/utils/background_service.dart';
import 'package:consume_api/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/db/database_helper.dart';
import 'data/preferences/preferences_helper.dart';
import 'provider/preferences_provider.dart';
// import 'provider/scheduling_provider.dart';
import 'screen/resto_detail.dart';
import 'screen/search_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  // await AndroidAlarmManager.initialize();
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => RestaurantSearchProvider(apiService: ApiService())),
        ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())),
        // ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => const HomePage(),
              RestoDetails.routeName: (context) => RestoDetails(
                  id: ModalRoute.of(context)?.settings.arguments as String),
              SearchPage.routeName: (context) => const SearchPage(),
              // SettingPage.routeName: (context) => const SettingPage()
            },
          );
        },
      ),
    );
  }
}
