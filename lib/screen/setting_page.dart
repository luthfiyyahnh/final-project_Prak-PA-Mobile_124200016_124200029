import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consume_api/provider/preferences_provider.dart';
import 'package:consume_api/provider/scheduling_provider.dart';
import 'package:consume_api/widgets/custom_dialog.dart';

class SettingPage extends StatefulWidget {
  static const routeName = '/setting_page';
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Hero(
              tag: 'option',
              child: Text(
                'Option',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              )),
          Material(
            child: ListTile(
              title: const Text('Scheduling Daily Restaurant'),
              // trailing: Consumer<SchedulingProvider>(
              //   builder: (context, scheduled, _) {
              //     return Switch.adaptive(
              //         value: provider.isDailyRestoActive,
              //         onChanged: (val) async {
              //           if (Platform.isIOS) {
              //             customDialog(context);
              //           } else {
              //             scheduled.scheduledNews(val);
              //             provider.enableDailyResto(val);
              //           }
              //         });
              //   },
              // ),
            ),
          )
        ],
      );
    });
  }
}
