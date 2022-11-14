import '../login_page.dart';
import '../models/m_uni/uni.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '/pages/search/search_uni.dart';

class HomePagemain extends StatefulWidget {
  const HomePagemain({Key? key}) : super(key: key);

  @override
  State<HomePagemain> createState() => _HomePagemainState();
}

class _HomePagemainState extends State<HomePagemain> {
  TextEditingController textInput = TextEditingController();

  var getUniApiUrl = "https://www.2ebook.com/new/2ebook_mobile/get_uni.php";
  List<Result?> uniList = [];
  var urlWeb = '';

  void get_uni() {
    final uri = Uri.parse(getUniApiUrl);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);

        setState(() {
          uniList = getuni.fromJson(decodedData).result as List<Result?>;
        });
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    get_uni();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(4, 8), // Shadow position
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Search your library",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextField(
                          controller: textInput,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Find your Libraly..',
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade600),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return searchloadingUni(text: textInput.text);
                            // return searchloading();
                          }));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        // splashColor: Color(0xfff012AC0),
                        // color: Colors.orange,
                        child: Text(
                          "SEARCH",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Spacer(
              //   flex: 1, // <-- SEE HERE
              // ),

              Expanded(
                  child: GridView.builder(
                itemCount: uniList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                  mainAxisExtent: 140,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    //borderRadius: BorderRadius.circular(20),
                    child: (uniList[index]!.uniName != null &&
                            uniList[index]!.uniId != '1')
                        ? InkWell(
                            onTap: () {
                              if (uniList[index]!.t4Id.toString() == '1') {
                                urlWeb =
                                    "https://www.2ebook.com/new/2ebook_mobile";
                              } else {
                                urlWeb =
                                    "${uniList[index]!.uniLink}/2ebook_api";
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => login(
                                          uniSname:
                                              uniList[index]!.uniSname ?? '',
                                          uniId:
                                              uniList[index]!.uniId.toString(),
                                          uniLink: urlWeb,
                                          pathWebSite: uniList[index]!
                                              .uniLink
                                              .toString(),
                                        )),
                              );
                            },
                            child: SizedBox(
                                child: Column(children: [
                              Expanded(
                                child: Container(
                                  height: 500,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          uniList[index]!.imgLink.toString()),
                                      fit: BoxFit.fill,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 4,
                                        offset: Offset(4, 8), // Shadow position
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                  child: Text(
                                      uniList[index]!.uniName.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                              // const SizedBox(height: 15),
                            ])))
                        : Image.asset('assets/images/logo_2ebook.png'),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
