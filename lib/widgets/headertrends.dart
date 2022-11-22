import 'package:easy_localization/easy_localization.dart';

import '../constants/colors.dart';
import 'package:flutter/material.dart';
import '../generated/locale_keys.g.dart';
import '../pages/booklist_homepage.dart';

class HeaderTrends extends StatelessWidget {
  const HeaderTrends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
              child: Text(LocaleKeys.book_recommended.tr(),
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: AnimeUI.cyan, fontWeight: FontWeight.bold))),
          InkWell(
            child: Text(
              LocaleKeys.view_all.tr(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(color: AnimeUI.cyan, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => booklist(indexTap: 1)),
              );
            },
          )
        ],
      ),
    );
  }
}
