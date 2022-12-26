import 'package:anime_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../pages/book_favorites.dart';
import '../pages/book_history_borrow.dart';
import '../pages/user_profile.dart';
import '../pages/booklist_homepage.dart';
import '../pages/setting.dart';
import '../pages/splashScreen.dart';
import '../pages/mainpage.dart';

class PublicDrawer extends StatefulWidget {
  const PublicDrawer({Key? key}) : super(key: key);

  @override
  _PublicDrawerState createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  var userName;
  var userEmail;

  @override
  void initState() {
    super.initState();
    getuserData();
  }

  getuserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String? _userLoginname = prefs.getString('userLoginname');
      String? _userEmail = prefs.getString('userEmail');
      userName = _userLoginname;
      userEmail = _userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${LocaleKeys.user.tr()} : ${userName}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text('${LocaleKeys.email.tr()} : ${userEmail}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            currentAccountPicture: CircleAvatar(
              foregroundImage: AssetImage('assets/images/icon-256x256.png'),
            ),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(20.0),
              //     bottomRight: Radius.circular(20.0)),
              image: DecorationImage(
                image: AssetImage('assets/images/image-leftmenu.jpeg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.bookmark,
              color: Colors.blue,
            ),
            title: Text(LocaleKeys.bookshelf.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(selectedPage: 1)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: Text(LocaleKeys.book_faverite.tr()),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => book_faverites()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.access_time,
              color: Colors.grey[600],
            ),
            title: Text(LocaleKeys.book_history.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => bookHistoryBorrow()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.attach_file,
              color: Colors.green,
            ),
            title: Text(LocaleKeys.data_frofile.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => userProfile()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(LocaleKeys.menu.tr()),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.orange,
            ),
            title: Text(LocaleKeys.homepage.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(selectedPage: 0)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book,
              color: Colors.greenAccent,
            ),
            title: Text(LocaleKeys.newBook.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => booklist(indexTap: 0)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.recommend,
              color: Colors.blue,
            ),
            title: Text(LocaleKeys.book_recommended.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => booklist(indexTap: 1)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            title: Text(LocaleKeys.book_popular.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => booklist(indexTap: 2)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.pink,
            ),
            title: Text(LocaleKeys.book_category.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(selectedPage: 2)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.fax,
              color: Colors.deepOrange,
            ),
            title: Text(LocaleKeys.book_publisher.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(selectedPage: 3)),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: Text(LocaleKeys.setting.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => setting()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(LocaleKeys.logout.tr()),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('isLoggedIn');
              await prefs.remove('userId');
              await prefs.remove('uniId');
              await prefs.remove('userName');
              await prefs.remove('userLastname');
              await prefs.remove('userEmail');
              await prefs.remove('userMobileno');
              await prefs.remove('userHomeno');
              await prefs.remove('userAddress');
              await prefs.remove('userState');
              await prefs.remove('userPostcode');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => splashScreen()));
            },
          ),
        ],
      ),
    );
  }
}
