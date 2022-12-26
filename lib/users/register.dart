import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'dart:async';
import '../generated/locale_keys.g.dart';
import '../login_page.dart';
import '../models/m_user/user_register.dart';
import 'package:http/http.dart' as http;

class register extends StatefulWidget {
  final String uniSname;
  final String pathWebSite;
  final String uniLink;
  final String uniId;

  const register({
    Key? key,
    required this.uniSname,
    required this.pathWebSite,
    required this.uniLink,
    required this.uniId,
  }) : super(key: key);
  @override
  _registerState createState() => _registerState(
      uniSname: uniSname, pathWebSite: pathWebSite, uniLink: uniLink);
}

class _registerState extends State<register> {
  String uniSname;
  String pathWebSite;
  String uniLink;
  _registerState(
      {required this.uniSname,
      required this.pathWebSite,
      required this.uniLink});

  TextEditingController userController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmdPasswordController = TextEditingController();
  List<Result?> userData = [];
  List<Result?> dataUni = [];
  bool _isSecurePassword = true;
  bool _isSecureConfirmPassword = true;
  final formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    getIpData();
  }

  void getIpData() async {
    final ipv4 = await Ipify.ipv4();
    var getUniRegister =
        "${uniLink}/checkUniRegister.php?uni_id=${widget.uniId}";
    final uri = Uri.parse(getUniRegister);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        if (decodedData['result'] == 'on') {
          // check ip for register on=check / off=not check

          var ipUrl =
              "${uniLink}/check_ip.php?DNSaddress=${ipv4}&uni_id=${widget.uniId}";
          final uriIP = Uri.parse(ipUrl);
          http.get(uriIP).then((responses) async {
            if (responses.statusCode == 200) {
              final responseBodyIp = responses.body;
              final decodedDataIP = jsonDecode(responseBodyIp);

              if (decodedDataIP['status'] == 'false') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(LocaleKeys.createNewAccount.tr()),
                      content: Text(LocaleKeys.regis_error_ip.tr()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => login(
                                        uniSname: widget.uniSname,
                                        uniId: widget.uniId,
                                        uniLink: uniLink,
                                        pathWebSite: pathWebSite,
                                      )),
                            );
                          },
                          child: Text(LocaleKeys.backToLogin.tr()),
                        ),
                      ],
                    );
                  },
                );
              }

              print('Test ==> ${decodedDataIP['status']}');
            }
          });
        }
      }
    });
  }

  Future doRegister(String user, firstname, lastname, password, uniId, unisname,
      email) async {
    // var registerApiUrl =
    //     "${widget.uniLink}/register.php?username=$user&email=$email&password=$password&uni_id=$uniId&uni_sname=$unisname";
    // print(registerApiUrl);
    try {
      Response response =
          await post(Uri.parse('${widget.uniLink}/register.php'), body: {
        'username': user,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'uni_id': uniId,
        'uni_sname': unisname
      });

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(LocaleKeys.register_success.tr()),
              content: Text(LocaleKeys.register_success_detail.tr()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => login(
                                uniSname: widget.uniSname,
                                uniId: widget.uniId,
                                uniLink: uniLink,
                                pathWebSite: pathWebSite,
                              )),
                    );
                  },
                  child: Text(LocaleKeys.yes.tr()),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(LocaleKeys.loginFailed.tr()),
          content: Text(LocaleKeys.PleaseFillCurrectWord.tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => login(
                            uniSname: widget.uniSname,
                            uniId: widget.uniId,
                            uniLink: uniLink,
                            pathWebSite: pathWebSite,
                          )),
                );
              },
              child: Text('Go to login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Form(
        key: formKey,
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
                        const Expanded(
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
                                          top: size.width * .05,
                                          bottom: size.width * .025,
                                        ),
                                        child: Text(
                                          LocaleKeys.createNewAccount.tr(),
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                    255, 255, 255, 255)
                                                .withOpacity(.8),
                                          ),
                                        ),
                                      ),

                                      // username
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
                                          validator: (String? valueusername) {
                                            if (valueusername!.isEmpty) {
                                              return 'please enter username';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      // fristname
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
                                          controller: firstNameController,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.account_box_outlined,
                                              color:
                                                  Colors.white.withOpacity(.8),
                                            ),
                                            border: InputBorder.none,
                                            hintMaxLines: 1,
                                            hintText: LocaleKeys.firstName.tr(),
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                          ),
                                          validator: (String? valuefirstname) {
                                            if (valuefirstname!.isEmpty) {
                                              return 'please enter Firstname';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      // Last name
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
                                          controller: lastNameController,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.contact_page_outlined,
                                              color:
                                                  Colors.white.withOpacity(.8),
                                            ),
                                            border: InputBorder.none,
                                            hintMaxLines: 1,
                                            hintText: LocaleKeys.lastName.tr(),
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                          ),
                                          validator: (String? valueLastname) {
                                            if (valueLastname!.isEmpty) {
                                              return 'please enter Lastname';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      // email
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
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color:
                                                  Colors.white.withOpacity(.8),
                                            ),
                                            border: InputBorder.none,
                                            hintMaxLines: 1,
                                            hintText:
                                                LocaleKeys.form_email.tr(),
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                          ),
                                          validator: (String? valueEmail) {
                                            if (!((valueEmail!.contains('@')) &&
                                                (valueEmail.contains('.')))) {
                                              return 'Please Type Email in Exp. you@email.com';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      //password
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
                                          validator: (String? valuePassword) {
                                            if (valuePassword!.length < 6) {
                                              return 'Password More 6 Charactor';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      //confirm password
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
                                          controller:
                                              confirmdPasswordController,
                                          obscureText: _isSecureConfirmPassword,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.lock_outline,
                                              color:
                                                  Colors.white.withOpacity(.8),
                                            ),
                                            border: InputBorder.none,
                                            hintMaxLines: 1,
                                            hintText: LocaleKeys
                                                .confirm_password
                                                .tr(),
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                            suffixIcon: toggleConfirmPassword(),
                                          ),
                                          validator:
                                              (String? valueConfirmPassword) {
                                            if ((passwordController.text !=
                                                    confirmdPasswordController
                                                        .text) &&
                                                (confirmdPasswordController
                                                    .text.isEmpty)) {
                                              return 'Re-password is incurrect';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      SizedBox(height: size.width * .15),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            doRegister(
                                              userController.text.toString(),
                                              firstNameController.text
                                                  .toString(),
                                              lastNameController.text
                                                  .toString(),
                                              passwordController.text
                                                  .toString(),
                                              widget.uniId,
                                              widget.uniSname,
                                              emailController.text.toString(),
                                            );
                                            HapticFeedback.lightImpact();
                                            Fluttertoast.showToast(
                                              msg: LocaleKeys.alertSignIn.tr(),
                                            );
                                            // _showSuccessDialog();
                                          }
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
                                            LocaleKeys.createNewAccount.tr(),
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

  Widget toggleConfirmPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecureConfirmPassword = !_isSecureConfirmPassword;
        });
      },
      icon: _isSecureConfirmPassword
          ? Icon(Icons.visibility)
          : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
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
