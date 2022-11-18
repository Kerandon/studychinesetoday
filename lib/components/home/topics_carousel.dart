import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:studychinesetoday/configs/constants.dart';
import 'package:studychinesetoday/pages/all_topics_page.dart';
import 'package:studychinesetoday/state_management/topic_providers.dart';
import 'package:studychinesetoday/utils/methods.dart';
import 'package:studychinesetoday/components/home/topic_thumbail.dart';

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
    return SizedBox(
      width: size.width * 0.80,
      height: size.height * 0.60,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
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
                child: FutureBuilder(
                    future: getAllTopics(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error !! ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        final topics = snapshot.data!;
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          ref
                              .read(topicProvider.notifier)
                              .addTopics(topics: topics);
                        });

                        return Column(
                          children: [
                            Expanded(
                              child: CarouselSlider(
                                  options: CarouselOptions(
                                      autoPlay: true,
                                      height: size.height * 0.40,
                                      viewportFraction: 0.30),
                                  items: topics
                                      .map((topic) =>
                                          TopicThumbnail(topic: topic))
                                      .toList()),
                            ),
                          ],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
