import 'package:anime_app/constants/colors.dart';
import 'package:anime_app/users/register.dart';
import 'package:anime_app/widgets/webView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'dart:convert';
import 'dart:async';
import '../pages/splashScreen.dart';
import '../models/m_user/user_login.dart';
import 'generated/locale_keys.g.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

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
  _loginState createState() => _loginState(
      uniSname: uniSname,
      uniId: uniId,
      pathWebSite: pathWebSite,
      uniLink: uniLink);
}

class _loginState extends State<login> {
  String uniSname;
  String uniId;
  String pathWebSite;
  String uniLink;
  _loginState(
      {required this.uniSname,
      required this.uniId,
      required this.pathWebSite,
      required this.uniLink});

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Result?> userData = [];
  bool _isSecurePassword = true;

  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  Widget modalBookmark() {
    return Container(
      height: 600.0,
      child: WebViewExample(
        pathWebSite: pathWebSite,
        uniSname: uniSname,
      ),
    );
  }

  Future doLogin(String user, password, uniId) async {
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
          var uniSname = await prefs.setString(
              'uniSname', userData[0]!.uniSname.toString());

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
                    title: Text(LocaleKeys.loginFailed.tr()),
                    content: Text(LocaleKeys.PleaseFillCurrectWord.tr()),
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
                                          '${LocaleKeys.signin.tr()} ${uniSname.toUpperCase()}',
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
                                            hintText: LocaleKeys.username.tr(),
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                          ),
                                          validator: (String? username) {
                                            if (username!.isEmpty) {
                                              return 'Please enter username';
                                            } else {
                                              return null;
                                            }
                                          },
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
                                          obscureText: _isSecurePassword,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.lock_outline,
                                              color:
                                                  Colors.white.withOpacity(.8),
                                            ),
                                            border: InputBorder.none,
                                            hintMaxLines: 1,
                                            hintText: LocaleKeys.password.tr(),
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                            suffixIcon: togglePassword(),
                                          ),
                                          validator: (String? password) {
                                            if (password!.isEmpty) {
                                              return 'Please enter password';
                                            } else {
                                              return null;
                                            }
                                          },
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
                                              text: LocaleKeys.forgetPassword
                                                  .tr(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  HapticFeedback.lightImpact();
                                                  Fluttertoast.showToast(
                                                    msg: LocaleKeys
                                                        .alertForgetPassword
                                                        .tr(),
                                                  );
                                                },
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: LocaleKeys.createNewAccount
                                                  .tr(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return register(
                                                        uniLink: uniLink,
                                                        pathWebSite:
                                                            pathWebSite,
                                                        uniSname: uniSname,
                                                        uniId: uniId);
                                                    // return searchloading();
                                                  }));

                                                  HapticFeedback.lightImpact();
                                                  Fluttertoast.showToast(
                                                    msg: LocaleKeys
                                                        .alertCreateAccount
                                                        .tr(),
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
                                            msg: LocaleKeys.alertSignIn.tr(),
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
                                            LocaleKeys.buttonSignin.tr(),
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

  Future showSheet() => showSlidingBottomSheet(context,
      builder: (context) => SlidingSheetDialog(
            cornerRadius: 16,
            avoidStatusBar: true,
            snapSpec: const SnapSpec(
              initialSnap: 0.8,
              snappings: [0.4, 0.8, 0.9],
            ),
            builder: buildSheet,
            headerBuilder: buildHeader,
          ));

  Widget buildSheet(context, state) => Material(
        child: ListView(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.all(16),
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: AnimeUI.cyan,
                    shape: StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 40)),
                child: Text(LocaleKeys.close.tr()),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  modalBookmark(),
                ],
              ),
            ]),
      );

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? Icon(Icons.visibility)
          : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}

Widget buildHeader(BuildContext context, SheetState state) => Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          Center(
            child: Container(
              // color: Colors.blue,
              width: 32,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );

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
