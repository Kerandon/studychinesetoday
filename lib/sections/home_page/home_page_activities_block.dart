import 'package:flutter/material.dart';
import 'package:studychinesetoday/sections/home_page/tile_title.dart';
import '../../configs/app_theme.dart';
import '../../configs/constants_other.dart';
import '../games/sentence_scrambler/sentence_scrambler_main.dart';
import 'home_page_tile.dart';

class HomePageActivitiesTile extends StatelessWidget {
  const HomePageActivitiesTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * kHomePageTileWidth,
      height: size.height * 0.30,
      decoration: kBuildGreyBoxDecoration(),
      child: Column(
        children: [
          const TileTitle(title: 'Vocabulary Booster Activities'),
          Expanded(
            child: Row(
              children: [
                HomePageTile(
                  title: 'Memory Game',
                  callback: () {},
                ),
                HomePageTile(
                  title: 'Flash Cards',
                  callback: () {},
                ),
                HomePageTile(
                  title: 'Sentence Builder',
                  callback: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SentenceScramblerMain()));
                  },
                ),
                HomePageTile(
                  title: 'Vocabulary Quiz',
                  callback: () {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
