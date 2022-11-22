import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../generated/locale_keys.g.dart';
import '../../models/m_uni/uni.dart';
import '../../login_page.dart';
import '../../home_page.dart';
import '../../constants/colors.dart';

class searchloadingUni extends StatefulWidget {
  var text;
  searchloadingUni({@required this.text});

  @override
  State<searchloadingUni> createState() => _searchloadingUniState();
}

class _searchloadingUniState extends State<searchloadingUni> {
  List<Result?> dataUniSearch = [];
  var dataBook;
  var urlWeb;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  void getdata() async {
    print('input is : ${widget.text}');

    var getResultUni =
        "https://www.2ebook.com/new/2ebook_mobile/search_uni.php?search=${widget.text}";
    final uri = Uri.parse(getResultUni);
    http.get(uri).then((response) async {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        setState(() {
          dataUniSearch = getuni.fromJson(decodedData).result as List<Result?>;
        });
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocaleKeys.search_result.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AnimeUI.cyan,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: dataUniSearch.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: (Container(
                      padding: EdgeInsets.all(10),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 239, 239, 239),
                          image: DecorationImage(
                              opacity: 0.4,
                              image: AssetImage("assets/overlay.png"),
                              fit: BoxFit.cover)),
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(dataUniSearch[index]!
                                        .imgLink
                                        .toString()),
                                    fit: BoxFit.fitHeight)),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Flexible(
                                  child: Text(
                                    dataUniSearch[index]!.uniName.toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    '${LocaleKeys.initials.tr()} : ${dataUniSearch[index]!.uniSname.toString()}',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // getisbn(index);
                                    if (dataUniSearch[index]!.t4Id.toString() ==
                                        '1') {
                                      urlWeb =
                                          "https://www.2ebook.com/new/2ebook_mobile";
                                    } else {
                                      urlWeb =
                                          "${dataUniSearch[index]!.uniLink}/2ebook_api";
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => login(
                                                uniSname: dataUniSearch[index]!
                                                        .uniSname ??
                                                    '',
                                                uniId: dataUniSearch[index]!
                                                    .uniId
                                                    .toString(),
                                                uniLink: dataUniSearch[index]!
                                                    .uniLink
                                                    .toString(),
                                                pathWebSite:
                                                    dataUniSearch[index]!
                                                        .uniLink
                                                        .toString(),
                                              )),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AnimeUI.cyan),
                                  // color: AnimeUI.cyan,
                                  child: Text(
                                    LocaleKeys.clickToLogin.tr(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  );
                }),
          )
        ],
      ),
    );
  }
}
