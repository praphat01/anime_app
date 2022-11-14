import 'package:flutter/material.dart';
import 'package:anime_app/login_page.dart';
import 'package:anime_app/models/m_uni/uni.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class listviewUni extends StatefulWidget {
  const listviewUni({Key? key}) : super(key: key);

  @override
  _listviewUniState createState() => _listviewUniState();
}

class _listviewUniState extends State<listviewUni> {
  var marvelApiUrl = "https://www.2ebook.com/new/2ebook_mobile/get_uni.php";
  List<Result?> mcuMoviesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarvelMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: mcuMoviesList.isNotEmpty
            ? GridView.builder(
                itemCount: mcuMoviesList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: (mcuMoviesList[index]!.uniName != null &&
                            mcuMoviesList[index]!.uniId != '1')
                        ? CachedNetworkImage(
                            imageUrl: mcuMoviesList[index]!.imgLink.toString(),
                            placeholder: (context, url) =>
                                Image.asset('assets/images/logo_2ebook.png'),
                            fit: BoxFit.fill,
                          )
                        : Image.asset('assets/images/logo_2ebook.png'),
                  );
                },
              )
            : Center(
                child: Container(
                width: 10,
                height: 10,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white70,
                  ),
                ),
              )));
  }

  void getMarvelMovies() {
    final uri = Uri.parse(marvelApiUrl);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        mcuMoviesList = getuni.fromJson(decodedData).result as List<Result?>;
        // print(mcuMoviesList.first!.uni_name);
        setState(() {});
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }
}
