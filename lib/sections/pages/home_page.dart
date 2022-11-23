import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/components/home/topics_carousel.dart';
import 'package:studychinesetoday/configs/app_colors.dart';
import 'package:studychinesetoday/state_management/topics_data.dart';
import 'package:studychinesetoday/utils/methods.dart';

import '../games/flashcards/flashcards_button.dart';
import '../games/memory/memory_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  late final Future<dynamic> futureAllTopicsData;

  @override
  void initState() {
    futureAllTopicsData = getAllTopicsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topicDataNotifier = ref.read(topicsDataProvider.notifier);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Chinese Today'),
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              FutureBuilder(
                future: futureAllTopicsData,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    return Text('error ! ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      topicDataNotifier.addAllTopicsData(
                          allTopicsData: snapshot.data);
                    },
                    );

                    return Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(child: FlashcardsButton()),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.offWhite,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MemoryPage()));
                                  },
                                  child: Text(
                                    'Memory',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(color: Colors.black),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const TopicsCarousel(),
                      ],
                    );
                  } else {
                    return SizedBox(
                        width: size.width * 0.20,
                        height: size.width * 0.20,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  }
                },
              )
            ],
          ),
        ),
      ),
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
    );
  }
}
