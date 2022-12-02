import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/utils/firebase_methods.dart';
import '../../state_management/topics_data.dart';
import 'all_topics_carousel.dart';
import 'home_page_activities_block.dart';

class HomePageMain extends ConsumerStatefulWidget {
  const HomePageMain({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageMain> createState() => _HomePage2State();
}

class _HomePage2State extends ConsumerState<HomePageMain> {
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
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {
              topicDataNotifier.addAllTopicsData(allTopicsData: snapshot.data);
            },
          );
        }
        if (snapshot.hasError) {}

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
                  const Center(
                    child: HomePageActivitiesTile(),
                  ),
                  buildGap(size),
                  const Center(
                    child: AllTopicsCarousel(),
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
