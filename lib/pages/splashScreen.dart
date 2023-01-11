import 'dart:async';
import 'package:flutter/material.dart';
import '/home_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import '../pages/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  late StreamSubscription subscription;
  var isDeviceConnected = false;

  @override
  void initState() {
    super.initState();
    GetConnecttivity();
    main();
  }

  Future GetConnecttivity() async {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      setState(() {
        isDeviceConnected;
      });
    });
  }

  Future<void> main() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? status = prefs.getBool('isLoggedIn');
    // print(status);
    // runApp(MaterialApp(
    //     home: status == true
    //         ? HomePage(selectedPage: 0, uni_id: '85')
    //         : SignUpScreen()));

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: status == true
                      ? Scaffold(
                          body: isDeviceConnected
                              ? AnimatedSplashScreen(
                                  // Have internet login
                                  duration: 5000, // speed
                                  splash: Container(
                                    height: 300,
                                    width: 300,
                                    child: Lottie.network(
                                        'https://assets6.lottiefiles.com/packages/lf20_DMgKk1.json',
                                        fit: BoxFit.cover),
                                  ),
                                  nextScreen: MainPage(selectedPage: 0),
                                )
                              : AnimatedSplashScreen(
                                  // No internet login
                                  duration: 5000, // speed
                                  splash: Container(
                                    height: 300,
                                    width: 300,
                                  ),
                                  nextScreen: MainPage(selectedPage: 0),
                                ),
                        )
                      : Scaffold(
                          body: isDeviceConnected
                              ? AnimatedSplashScreen(
                                  duration: 5000, // speed
                                  splash: Container(
                                    height: 300,
                                    width: 300,
                                    child: Lottie.network(
                                        'https://assets6.lottiefiles.com/packages/lf20_DMgKk1.json',
                                        fit: BoxFit.cover),
                                  ),
                                  nextScreen: HomePagemain(),
                                )
                              : AnimatedSplashScreen(
                                  duration: 5000, // speed
                                  splash: Container(
                                    height: 300,
                                    width: 300,
                                  ),
                                  nextScreen: HomePagemain(),
                                ),
                        ),
                )));

    // runApp();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
