import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated/locale_keys.g.dart';

class userProfile extends StatefulWidget {
  const userProfile({Key? key}) : super(key: key);

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  var userName;
  var userLastname;
  var userEmail;
  var userMobileno;
  var userHomeno;
  var userAddress;
  var userState;
  var userPostcode;
  var userLoginname;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? _userName = prefs.getString('userName');
      String? _userLastname = prefs.getString('userLastname');
      String? _userEmail = prefs.getString('userEmail');
      String? _userMobileno = prefs.getString('userMobileno');
      String? _userHomeno = prefs.getString('userHomeno');
      String? _userAddress = prefs.getString('userAddress');
      String? _userState = prefs.getString('userState');
      String? _userPostcode = prefs.getString('userPostcode');
      String? _userLoginname = prefs.getString('userLoginname');

      userName = _userName;
      userLastname = _userLastname;
      userEmail = _userEmail;
      userMobileno = _userMobileno;
      userHomeno = _userHomeno;
      userAddress = _userAddress;
      userState = _userState;
      userPostcode = _userPostcode;
      userLoginname = _userLoginname;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: AnimeUI.cyan,
        title: Text(
          LocaleKeys.data_frofile.tr(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: AnimeUI.cyan,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(
                      top: 30,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 10,
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage(
                          "assets/images/icon-256x256.png",
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "${userLoginname}",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.userData.tr(),
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    listProfile(Icons.person, LocaleKeys.fullName.tr(),
                        "${userName} ${userLastname}"),
                    listProfile(Icons.alternate_email, LocaleKeys.email.tr(),
                        "${userEmail}"),
                    listProfile(Icons.location_pin, LocaleKeys.location.tr(),
                        "${userAddress} ${userState} ${userPostcode}"),
                    listProfile(Icons.phone, LocaleKeys.homeNumber.tr(),
                        "${userHomeno}"),
                    listProfile(Icons.phone_android,
                        LocaleKeys.phoneNumber.tr(), "${userMobileno}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listProfile(IconData icon, String text1, String text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
