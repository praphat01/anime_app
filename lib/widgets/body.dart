import '../widgets/popular.dart';
import '../widgets/header.dart';
import '../widgets/recents.dart';
import '../widgets/trends.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: <Widget>[
        Header(),
        popular(),
        Trends(),
        Recents(),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 170,
          ),
        ),
      ],
    );
  }
}
