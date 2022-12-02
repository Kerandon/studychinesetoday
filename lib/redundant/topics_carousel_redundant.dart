// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:studychinesetoday/configs/constants_other.dart';
// import 'package:studychinesetoday/sections/home_page/topic_thumbail_redundant.dart';
// import 'package:studychinesetoday/state_management/topics_data.dart';
//
// import '../pages/all_topics_page.dart';
//
//
// class TopicsCarousel extends ConsumerWidget {
//   const TopicsCarousel({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     bool pageCollapsed = false;
//     final size = MediaQuery.of(context).size;
//     if (size.width < kCollapseScreenWidth) {
//       pageCollapsed = true;
//     } else {
//       pageCollapsed = false;
//     }
//
//     final topicDataState = ref.watch(topicsDataProvider);
//
//     return SizedBox(
//       width: size.width * kHomePageTileWidth,
//       height: size.height * 0.50,
//       child: Column(
//         children: [
//           SizedBox(
//             height: size.height * 0.02,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               pageCollapsed
//                   ? const SizedBox()
//                   : SizedBox(
//                       width: size.width * 0.12,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => const AllTopics()));
//                         },
//                       ),
//                     ),
//             ],
//           ),
//           SizedBox(
//             height: size.height * 0.02,
//           ),
//           Expanded(
//             flex: 4,
//             child: SizedBox(
//               width: size.width * 0.90,
//             child: CarouselSlider(items: topicDataState.allTopicsData.map((e) => TopicThumbnail(topic: e)).toList(),
//                 options: CarouselOptions(
//                   viewportFraction: pageCollapsed ? 0.90 : 0.20,
//                   autoPlay: true
//                 )
//             ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
