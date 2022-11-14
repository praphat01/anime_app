import 'package:flutter/material.dart';
import '/home_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import '../pages/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    main();
  }

  Future<void> main() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? status = prefs.getBool('isLoggedIn');
    print(status);
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
                          body: AnimatedSplashScreen(
                            duration: 5000, // speed
                            splash: Container(
                              height: 300,
                              width: 300,
                              child: Lottie.network(
                                  'https://assets6.lottiefiles.com/packages/lf20_DMgKk1.json',
                                  fit: BoxFit.cover),
                            ),
                            nextScreen: MainPage(selectedPage: 0),
                          ),
                        )
                      : Scaffold(
                          body: AnimatedSplashScreen(
                            duration: 5000, // speed
                            splash: Container(
                              height: 300,
                              width: 300,
                              child: Lottie.network(
                                  'https://assets6.lottiefiles.com/packages/lf20_DMgKk1.json',
                                  fit: BoxFit.cover),
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
