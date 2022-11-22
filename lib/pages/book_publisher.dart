import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../generated/locale_keys.g.dart';
import '../widgets/leftmenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/m_publisher/publisher.dart';
import '../constants/colors.dart';
import '../pages/book_subPublisher.dart';
import '../pages/search/search.dart';

class bookPublisher extends StatefulWidget {
  const bookPublisher({Key? key}) : super(key: key);

  @override
  State<bookPublisher> createState() => _bookPublisherState();
}

class _bookPublisherState extends State<bookPublisher> {
  List<Result?> dataPublisher = [];
  late int uni_id;

  void getBookCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniId = prefs.getString('uniId');
    final String? uniLink = prefs.getString('uniLink');

    var getPublisher = "${uniLink}/publisher.php?uni_id=${uniId}";
    final uri = Uri.parse(getPublisher);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        setState(() {
          dataPublisher =
              publisher.fromJson(decodedData).result as List<Result?>;
        });
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getBookCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            LocaleKeys.menu_publisher.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AnimeUI.cyan,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => searchPage()),
                );
                // showSearch(
                //   context: context,
                //   delegate: MySearchDelegate(),
                // );
              },
            ),
          ],
        ),
        drawer: PublicDrawer(),
        body: ListView.builder(
          itemCount: dataPublisher.length,
          itemBuilder: (context, index) {
            if (dataPublisher[index]!.bookCount.toString() != "0") {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        AssetImage('assets/images/publisher_pic.jpeg'),
                  ),
                  title: Text(
                      '${dataPublisher[index]!.bookcateName.toString()} (${dataPublisher[index]!.bookCount.toString()})'),
                  // subtitle: Text(user.email),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => subPublisherList(
                        bookcate_id:
                            dataPublisher[index]!.bookcateId.toString(),
                        bookcate_name: dataPublisher[index]!.bookcateName ?? '',
                      ),
                    ));
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
