import 'package:flutter/material.dart';
import '../tabs/bookAddedpage.dart';
import '../tabs/poppularpage.dart';
import '../tabs/recommendedpage.dart';
import '../constants/colors.dart';

class booklist extends StatefulWidget {
  final int indexTap;
  const booklist({Key? key, required this.indexTap}) : super(key: key);

  @override
  State<booklist> createState() => _booklistState(indexTap: indexTap);
}

class _booklistState extends State<booklist> {
  int indexTap;
  _booklistState({required this.indexTap});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: indexTap,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "All Book.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AnimeUI.cyan,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.grey,
            labelColor: AnimeUI.cyan,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'หนังสือใหม่',
                icon: Icon(
                  Icons.book,
                ),
              ),
              Tab(
                text: 'หนังสือแนะนำ',
                icon: Icon(
                  Icons.recommend,
                ),
              ),
              Tab(
                text: 'หนังสือยอดนิยม',
                icon: Icon(
                  Icons.star,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Page book added
            bookAdded(),

            // Page book recomment
            bookRecommended(),

            // Page book poppular
            bookPoppular(),
          ],
        ),
      ),
    );
  }
}
