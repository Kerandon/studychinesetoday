// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:studychinesetoday/sections/home_page/topics_carousel_redundant.dart';
// import 'package:studychinesetoday/configs/app_colors.dart';
// import 'package:studychinesetoday/configs/app_theme.dart';
// import 'package:studychinesetoday/configs/constants_other.dart';
// import 'package:studychinesetoday/state_management/topics_data.dart';
// import 'package:studychinesetoday/utils/firebase_methods.dart';
//
// import '../games/flashcards/flashcards_button.dart';
// import '../games/memory/memory_page.dart';
// import 'home_page_tile.dart';
//
// class HomePage extends ConsumerStatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<HomePage> createState() => HomePageState();
// }
//
// class HomePageState extends ConsumerState<HomePage> {
//   final ScrollController _scrollController = ScrollController();
//
//   late final Future<dynamic> futureAllTopicsData;
//
//   @override
//   void initState() {
//     futureAllTopicsData = getAllTopicsData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final topicDataNotifier = ref.read(topicsDataProvider.notifier);
//
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Study Chinese Today'),
//       ),
//       body: Scrollbar(
//         controller: _scrollController,
//         child: SingleChildScrollView(
//           controller: _scrollController,
//           child: Column(
//             children: [
//               Container(
//                 width: size.width * kHomePageTileWidth,
//                 height: size.height * 0.30,
//                 decoration: BoxDecoration(
//                   color: AppColors.offWhite,
//                   borderRadius: BorderRadius.circular(kRadius),
//                   boxShadow: kBoxShadow,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Expanded(
//                       child: HomePageTile(
//                         title: 'Flashcards', callback: () {  },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               FutureBuilder(
//                 future: futureAllTopicsData,
//                 builder:
//                     (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                   if (snapshot.hasError) {
//                     throw Exception(snapshot.error);
//                   }
//                   if (snapshot.hasData) {
//                     WidgetsBinding.instance.addPostFrameCallback(
//                       (timeStamp) {
//                         topicDataNotifier.addAllTopicsData(
//                             allTopicsData: snapshot.data);
//                       },
//                     );
//
//                     return Container(
//                       width: double.infinity,
//                       color: Colors.amber,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//
//                           const TopicsCarousel(),
//                         ],
//                       ),
//                     );
//                   } else {
//                     return SizedBox(
//                         width: size.width * 0.20,
//                         height: size.width * 0.20,
//                         child:
//                             const Center(child: CircularProgressIndicator()));
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

