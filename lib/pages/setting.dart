import 'package:anime_app/pages/splashScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../constants/colors.dart';
import '../generated/locale_keys.g.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.setting.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AnimeUI.cyan,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text(
                  LocaleKeys.language.tr(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Divider(height: 30, thickness: 1),
            // SizedBox(height: 5),
            buildSettingOption(context, LocaleKeys.changeLanguage.tr())
          ],
        ),
      ),
    );
  }

  GestureDetector buildSettingOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _checkLanguageNow(),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (context.locale == Locale('en')) {
                          context.setLocale(Locale('th'));
                        } else {
                          context.setLocale(Locale('en'));
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => splashScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AnimeUI.cyan, // Background color
                      ),
                      icon: const Icon(
                        Icons.language,
                        size: 24.0,
                      ),
                      label: Text(
                        LocaleKeys.chageLanguageTo.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(LocaleKeys.close.tr())),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600]),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkLanguageNow() {
    if (context.locale == Locale('en')) {
      return Text('${LocaleKeys.language.tr()} : ${LocaleKeys.english.tr()}');
    } else {
      return Text('${LocaleKeys.language.tr()} : ${LocaleKeys.thai.tr()}');
    }
  }
}

// command for genarate update word 
// step 1 :  Deletefile locale_keys.g.dart
// step 2 :  flutter pub run easy_localization:generate -S "assets/translations"
// step 3 :  flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart -S "assets/translation