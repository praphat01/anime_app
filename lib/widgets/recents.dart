import 'package:easy_localization/easy_localization.dart';

import '../constants/colors.dart';
import '../generated/locale_keys.g.dart';
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
          aspectRatio: 1.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(LocaleKeys.newBook.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: AnimeUI.cyan,
                                    fontWeight: FontWeight.bold))),
                    InkWell(
                      child: Text(
                        LocaleKeys.view_all.tr(),
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
              SizedBox(
                // height: 108,
                child: const RecentsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
