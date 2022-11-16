import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:studychinesetoday/configs/constants.dart';
import 'package:studychinesetoday/pages/all_topics_page.dart';
import 'package:studychinesetoday/state_management/simple_providers.dart';
import 'package:studychinesetoday/utils/methods.dart';
import 'package:studychinesetoday/components/home/topic_thumbail.dart';

class TopicsCarousel extends ConsumerWidget {
  const TopicsCarousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
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
                      child: Text(
                        'Build your vocabulary by topic!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AllTopics()));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          const Text(
                            'See all topics',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          const Icon(Icons.arrow_forward)
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
                    future: getAllTopics(ref: ref),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error !! ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        final topics = snapshot.data!;
                        ref.read(allTopics).addAll(topics);
                        return Column(
                          children: [
                            Expanded(
                              child: CarouselSlider(
                                  options: CarouselOptions(
                                      autoPlay: true,
                                      height: size.height * 0.40,
                                      viewportFraction: 0.30),
                                  items: topics
                                      .map(
                                          (topic) => TopicThumbnail(topic: topic))
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
