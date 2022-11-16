import 'package:flutter/material.dart';
import 'package:studychinesetoday/components/home/topics_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
                                child: Text(
                                  'Studying Chinese today couldn\'t be easier - with these handy tools at your fingertips!',
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
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
                const TopicsCarousel()
              ],
            )),
      ),
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
    );
  }
}
