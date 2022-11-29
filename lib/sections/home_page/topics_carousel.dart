import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/configs/constants.dart';
import 'package:studychinesetoday/sections/home_page/topic_thumbail.dart';
import 'package:studychinesetoday/state_management/topics_data.dart';

import '../pages/all_topics_page.dart';


class TopicsCarousel extends ConsumerWidget {
  const TopicsCarousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool pageCollapsed = false;
    final size = MediaQuery.of(context).size;
    if (size.width < kCollapseScreenWidth) {
      pageCollapsed = true;
    } else {
      pageCollapsed = false;
    }

    final topicDataState = ref.watch(topicsDataProvider);

    return SizedBox(
      width: size.width * kHomePageTileWidth,
      height: size.height * 0.50,
      child: Container(
        decoration: BoxDecoration(
          border: const Border.fromBorderSide(BorderSide(color: Colors.red)),
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width * 0.02),
                    child: AutoSizeText(
                      'Build your vocabulary by topic!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                      minFontSize: 15,
                      maxFontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                pageCollapsed
                    ? const SizedBox()
                    : SizedBox(
                        width: size.width * 0.12,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AllTopics()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              const AutoSizeText(
                                'See all topics',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                minFontSize: 8,
                                maxFontSize: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                width: size.width * 0.90,
              child: CarouselSlider(items: topicDataState.allTopicsData.map((e) => TopicThumbnail(topic: e)).toList(),
                  options: CarouselOptions(
                    viewportFraction: pageCollapsed ? 0.90 : 0.20,
                    autoPlay: true
                  )
              ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
