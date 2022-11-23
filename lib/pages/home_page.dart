import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/games/flashcards/flashcards_button.dart';
import 'package:studychinesetoday/components/home/topics_carousel.dart';
import 'package:studychinesetoday/configs/app_colors.dart';
import 'package:studychinesetoday/state_management/topics_data.dart';
import 'package:studychinesetoday/utils/methods.dart';

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
              SizedBox(
                width: double.infinity,
                height: size.height * 0.50,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: const Alignment(0.4, 0),
                            child: SizedBox(
                              width: size.width * 0.30,
                              child: AutoSizeText(
                                'Check out these easy tools',
                                style: Theme.of(context).textTheme.displayLarge,
                                minFontSize: 20,
                                maxFontSize: 40,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: const Alignment(-0.4, 0),
                            child: Padding(
                              padding: EdgeInsets.all(size.width * 0.02),
                              child: Image.asset(
                                  'assets/images/app/background_main.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                    });

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: FlashcardsButton()),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.offWhite,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemoryPage()));
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
                        TopicsCarousel(),
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
