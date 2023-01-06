import 'package:anime_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/sliver_head_delegate.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  var uniFullnameData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuniSname();
  }

  Future getuniSname() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uniFullname = prefs.getString('uniFullname');

    setState(() {
      uniFullnameData = uniFullname;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600;
    return useMobileLayout
        ? bodyContentMobile(context)
        : bodyContentTablet(context);
  }

  SliverPersistentHeader bodyContentMobile(BuildContext context) {
    // For Mobile
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
                      uniFullnameData.toString(),
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

  SliverPersistentHeader bodyContentTablet(BuildContext context) {
    // For Tablet
    return SliverPersistentHeader(
      floating: true,
      delegate: SliverCustomHeaderDelegate(
        minHeight: 60,
        maxHeight: 100,
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
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                          color: AnimeUI.cyan, fontWeight: FontWeight.bold),
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
                    .headline6
                    ?.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
