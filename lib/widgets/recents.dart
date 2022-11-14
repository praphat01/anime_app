import '../constants/colors.dart';
import '../widgets/recentslist.dart';
import 'package:flutter/material.dart';
import '../pages/booklist_homepage.dart';

class Recents extends StatelessWidget {
  const Recents({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: AspectRatio(
          aspectRatio: 16 / 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Text("หนังสือใหม่",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: AnimeUI.cyan,
                                    fontWeight: FontWeight.bold))),
                    InkWell(
                      child: Text(
                        "View all",
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: AnimeUI.cyan, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => booklist(indexTap: 0)),
                        );
                      },
                    )
                  ],
                ),
              ),
              const RecentsList()
            ],
          ),
        ),
      ),
    );
  }
}
