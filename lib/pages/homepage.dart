import '../widgets/body.dart';
import 'package:flutter/material.dart';
import '../widgets/leftmenu.dart';
import '../pages/search/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            },
          ),
        ],
      ),
      drawer: PublicDrawer(),
      body: SafeArea(
        child: Stack(
          children: [const Body()],
        ),
      ),
    );
  }
}
