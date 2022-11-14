import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import '../pages/splashScreen.dart';
import '../models/m_user/user_login.dart';

class login extends StatefulWidget {
  final String uniSname;
  final String uniId;
  final String uniLink;
  final String pathWebSite;

  const login({
    Key? key,
    required this.uniSname,
    required this.uniId,
    required this.uniLink,
    required this.pathWebSite,
  }) : super(key: key);
  @override
  _loginState createState() => _loginState(uniSname: uniSname, uniId: uniId);
}

class _loginState extends State<login> {
  String uniSname;
  String uniId;
  _loginState({required this.uniSname, required this.uniId});

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Result?> userData = [];

  Future doLogin(String user, password, uniId) async {
    print(widget.uniLink);
    try {
      Response response = await post(
          Uri.parse('${widget.uniLink}/login_lib.php'),
          body: {'user': user, 'pass': password, 'uni_id': uniId});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        userData = user_login.fromJson(data).result as List<Result?>;

        print(userData[0]!.userId);

        if (data['status'] == 'true') {
          // print(data);
          print('Login successfully');
          final prefs = await SharedPreferences.getInstance();

          // Set data for shared_preferences
          var status = await prefs.setBool('isLoggedIn', true);

          var userId =
              await prefs.setString('userId', userData[0]!.userId.toString());
          var uniId =
              await prefs.setString('uniId', userData[0]!.uniId.toString());
          var userLoginname = await prefs.setString(
              'userLoginname', userData[0]!.userLoginname.toString());
          var userName = await prefs.setString(
              'userName', userData[0]!.userName.toString());
          var userLastname = await prefs.setString(
              'userLastname', userData[0]!.userLastname.toString());
          var userEmail = await prefs.setString(
              'userEmail', userData[0]!.userEmail.toString());
          var userMobileno = await prefs.setString(
              'userMobileno', userData[0]!.userMobileno.toString());
          var userHomeno = await prefs.setString(
              'userHomeno', userData[0]!.userHomeno.toString());
          var userAddress = await prefs.setString(
              'userAddress', userData[0]!.userAddress.toString());
          var userState = await prefs.setString(
              'userState', userData[0]!.userState.toString());
          var userPostcode = await prefs.setString(
              'userPostcode', userData[0]!.userPostcode.toString());
          var uniLink = await prefs.setString('uniLink', widget.uniLink);
          var pathWebSite =
              await prefs.setString('pathWebSite', widget.pathWebSite);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => splashScreen()));
          print(status);
        } else {
          Widget okButton = TextButton(
            child: Text("OK"),
            onPressed: () {},
          );

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("ล็อกอินผิดพลาด"),
                    content: Text("กรุณากรอกข้อมูลให้ถูกต้อง!!"),
                    actions: [
                      okButton,
                    ],
                  ));
          print('Login failed password is wrong!');
        }
      } else {
        print('Connect server is failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Form(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  SizedBox(
                    height: size.height,
                    child: Image.asset(
                      'assets/images/Coffee-Magazine (1).jpeg',
                      // #Image Url: https://unsplash.com/photos/bOBM8CB4ZC4
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        // Text('uniSname is : ${uniSname}'),
                        // Text('uni_id is : ${uniId}'),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 7,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                              child: Container(
                                color: Colors.black.withOpacity(0.08),
                                child: SizedBox(
                                  width: size.width * .9,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: size.width * .15,
                                          bottom: size.width * .1,
                                        ),
                                        child: Text(
                                          'SIGN IN ${uniSname}',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                    255, 255, 255, 255)
                                                .withOpacity(.8),
                                          ),
                                        ),
                                      ),
                                      // component(
                                      //   Icons.account_circle_outlined,
                                      //   'User name...',
                                      //   false,
                                      //   false,
                                      //   'userController',
                                      // ),
                                      // component(
                                      //   Icons.lock_outline,
                                      //   'Password...',
                                      //   true,
                                      //   false,
                                      //   'passwordController',
                                      // ),

                                      Container(
                                        height: size.width / 8,
                                        width: size.width / 1.25,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                            right: size.width / 30),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(.9),
                                          ),
                                          controller: userController,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.account_circle_outlined,
                                              color:
                                                  Colors.white.withOpacity(.8),
                                            ),
                                            border: InputBorder.none,
                                            hintMaxLines: 1,
                                            hintText: 'User name...',
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Container(
                                        height: size.width / 8,
                                        width: size.width / 1.25,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(
                                            right: size.width / 30),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(.9),
                                          ),
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.lock_outline,
                                              color:
                                                  Colors.white.withOpacity(.8),
                                            ),
                                            border: InputBorder.none,
                                            hintMaxLines: 1,
                                            hintText: 'Password...',
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // TextFormField(
                                      //   controller: passwordController,
                                      //   decoration: InputDecoration(
                                      //       hintText: 'Password'),
                                      // ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'Forgotten password!',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  HapticFeedback.lightImpact();
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'Forgotten password! button pressed',
                                                  );
                                                },
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Create a new Account',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  HapticFeedback.lightImpact();
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        'Create a new Account button pressed',
                                                  );
                                                },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.width * .3),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          doLogin(
                                            userController.text.toString(),
                                            passwordController.text.toString(),
                                            uniId,
                                          );
                                          HapticFeedback.lightImpact();
                                          Fluttertoast.showToast(
                                            msg: 'Sign-In button pressed',
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            bottom: size.width * .05,
                                          ),
                                          height: size.width / 8,
                                          width: size.width / 1.25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Sign-In',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget component(IconData icon, String hintText, bool isPassword,
  //     bool isEmail, String datafiled) {
  //   Size size = MediaQuery.of(context).size;
  //   return Container(
  //     height: size.width / 8,
  //     width: size.width / 1.25,
  //     alignment: Alignment.center,
  //     padding: EdgeInsets.only(right: size.width / 30),
  //     decoration: BoxDecoration(
  //       color: Colors.black.withOpacity(.1),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: TextFormField(
  //       style: TextStyle(
  //         color: Colors.white.withOpacity(.9),
  //       ),
  //       obscureText: isPassword,
  //       keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
  //       decoration: InputDecoration(
  //         prefixIcon: Icon(
  //           icon,
  //           color: Colors.white.withOpacity(.8),
  //         ),
  //         border: InputBorder.none,
  //         hintMaxLines: 1,
  //         hintText: hintText,
  //         hintStyle: TextStyle(
  //           fontSize: 14,
  //           color: Colors.white.withOpacity(.5),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
