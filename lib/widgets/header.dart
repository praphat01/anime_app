import 'package:anime_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants/colors.dart';
import '../constants/sliver_head_delegate.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      delegate: SliverCustomHeaderDelegate(
        minHeight: 60,
        maxHeight: 60,
        child: Container(
          color: AnimeUI.background,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      LocaleKeys.title2ebook.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: AnimeUI.cyan),
                    ),
                  ),
                  // const Icon(Icons.search, color: Colors.black, size: 30)
                ],
              ),
              const SizedBox(height: 5),
              Text(
                LocaleKeys.headWellcome.tr(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
