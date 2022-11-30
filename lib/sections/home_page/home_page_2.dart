import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/components/app/loading_screen.dart';
import 'package:studychinesetoday/configs/app_colors.dart';
import 'package:studychinesetoday/configs/constants.dart';
import 'package:studychinesetoday/models/topic_data.dart';
import 'package:studychinesetoday/sections/home_page/topics_carousel.dart';
import 'package:studychinesetoday/sections/pages/all_topics_page.dart';
import 'package:studychinesetoday/utils/methods.dart';

import '../../configs/app_theme.dart';
import '../../state_management/topics_data.dart';
import 'home_page_tile.dart';

class HomePage2 extends ConsumerStatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends ConsumerState<HomePage2> {
  final ScrollController _scrollController = ScrollController();

  late final Future _allTopicsDataFuture;

  @override
  void initState() {
    _allTopicsDataFuture = getAllTopicsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topicDataNotifier = ref.read(topicsDataProvider.notifier);

    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _allTopicsDataFuture,
      builder: (context, snapshot) {
        bool hasTopicData = false;

        if (snapshot.hasData) {
          hasTopicData = true;
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              topicDataNotifier.addAllTopicsData(allTopicsData: snapshot.data);
            },
          );
        }
        if (snapshot.hasError) {
        }

        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 22, size.width * 0.10, 22),
                child: Image.asset('assets/images/app/background_main.png'),
              ),
            ],
            toolbarHeight: size.height * 0.20,
            title: Padding(
              padding: EdgeInsets.only(left: size.width * 0.10),
              child: Text(
                'Study Chinese Today',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          body: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  buildGap(size),
                  Center(
                    child: HomePageActivitiesTile(),
                  ),
                  buildGap(size),
                  Center(
                    child: AllTopicsHomePageTile(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox buildGap(Size size) {
    return SizedBox(
      height: size.height * 0.02,
    );
  }
}

class AllTopicsHomePageTile extends ConsumerWidget {
  const AllTopicsHomePageTile({
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

    List<String> topicItems = [];

    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * kHomePageTileWidth,
      height: size.height * 0.40,
      decoration: kBuildGreyBoxDecoration(),
      child: Column(
        children: [
          TileTitle(title: 'Learn Vocabulary by Topic'),
          //   SizedBox(height: size.height * 0.02,),
          Expanded(
            child: allWordsAsync.whenData( (value) {
              print(value.length);
              for(var v in value){
                print(v.english);
                topicItems.add(v.english);
              }
              return topicItems.isNotEmpty ? CarouselSlider(

                items: topicItems
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Container(
                          decoration:
                              kBuildGreyBoxDecoration(color: AppColors.offWhite),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  initialPage: 0,
                    autoPlay: true,
                    viewportFraction: 0.25,
                    height: size.height * 0.30),
              ) : LoadingScreen();
            }
            ).asData!.value
          ),
        ],
      ),
    );
  }
}

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
          TileTitle(title: 'Vocabulary Booster Activities'),
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
                  callback: () {},
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

class TileTitle extends StatelessWidget {
  const TileTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.05,
      width: double.infinity,
      child: Align(
        alignment: Alignment(-0.90, 0.50),
        child: Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}
