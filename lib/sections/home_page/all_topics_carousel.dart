import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/home_page/tile_title.dart';
import 'package:studychinesetoday/sections/home_page/topic_tile.dart';

import '../../components/app/loading_screen.dart';
import '../../configs/app_theme.dart';
import '../../configs/constants.dart';
import '../../models/topic_data.dart';
import '../../state_management/topics_data.dart';

class AllTopicsCarousel extends ConsumerWidget {
  const AllTopicsCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AutoDisposeFutureProvider<Set<TopicData>> allWords =
        FutureProvider.autoDispose<Set<TopicData>>((ref) {
      final allTopicsData = ref.watch(topicsDataProvider);
      return allTopicsData.allTopicsData;
    });

    final allWordsAsync = ref.watch(allWords);

    List<TopicData> topicItems = [];

    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * kHomePageTileWidth,
      height: size.height * 0.40,
      decoration: kBuildGreyBoxDecoration(),
      child: Column(
        children: [
          const TileTitle(title: 'Learn Vocabulary by Topic'),
          Expanded(
              child: allWordsAsync
                  .whenData((value) {
                    for (var v in value) {
                      topicItems.add(v);
                    }
                    return topicItems.isNotEmpty
                        ? CarouselSlider(
                            items: topicItems
                                .map(
                                  (e) => TopicTile(topicData: e),
                                )
                                .toList(),
                            options: CarouselOptions(
                                initialPage: 0,
                                autoPlay: true,
                                viewportFraction: 0.25,
                                height: size.height * 0.30),
                          )
                        : const LoadingScreen();
                  })
                  .asData!
                  .value),
        ],
      ),
    );
  }
}
