import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:consume_api/data/api/api_service_restaurant.dart';
import 'package:consume_api/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';

import '../common/navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (String? payload) async {
    //   if (payload != null) {
    //     print('notification payload: $payload');
    //   }
    //   selectNotificationSubject.add(payload ?? 'empty payload');
    // });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestoData restaurant) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "Restaurant Channel";

    // Android
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    // iOS
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    // Result notification
    var listResto = await ApiService().restoHeadline();
    int randomIndex = Random().nextInt(listResto.restaurants.length);
    var randomList = restaurant.restaurants[randomIndex];
    var titleNotification = "<b>Recommendation Restaurant</b>";
    var randomTitleResto = randomList.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, randomTitleResto, platformChannelSpecifics,
        payload: json.encode(restaurant.toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = RestoData.fromJson(json.decode(payload));
        var randomIndex = Random().nextInt(data.restaurants.length);
        var restaurant = data.restaurants[randomIndex];

        Navigation.intentWithData(route, restaurant);
      },
    );
  }
}
