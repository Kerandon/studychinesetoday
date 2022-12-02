// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:studychinesetoday/sections/pages/topic_page.dart';
// import 'package:studychinesetoday/utils/firebase_methods.dart';
//
// import '../../components/app/display_image.dart';
// import '../../configs/app_colors.dart';
// import '../../configs/constants_other.dart';
// import '../../models/topic_data.dart';
//
// class TopicThumbnail extends ConsumerStatefulWidget {
//   const TopicThumbnail({
//     super.key,
//     required this.topic,
//   });
//
//   final TopicData topic;
//
//   @override
//   ConsumerState<TopicThumbnail> createState() => _TopicThumbnailState();
// }
//
// class _TopicThumbnailState extends ConsumerState<TopicThumbnail> {
//
//   late final Future<String> _futureImage;
//
//   @override
//   void initState() {
//     _futureImage = getRandomTopicURL(topic: widget.topic);
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8),
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(kRadius),
//             color: AppColors.offWhite,
//             boxShadow: const [kShadow]),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(8, 8, 8, 1),
//               child: Text(
//                 widget.topic.english,
//                 style: Theme.of(context)
//                     .textTheme
//                     .headlineSmall
//                     ?.copyWith(overflow: TextOverflow.ellipsis),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topCenter,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     '${widget.topic.character} ',
//                     style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                         color: Colors.grey, overflow: TextOverflow.ellipsis),
//                   ),
//                   Text(
//                     ' ${widget.topic.pinyin}',
//                     style: Theme.of(context).textTheme.displaySmall!.copyWith(
//                         color: Colors.grey, overflow: TextOverflow.ellipsis),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 5,
//               child: DisplayImage(
//                 imageFuture: _futureImage,
//                 returnedURL: (url) {
//
//                 },
//                cachedURL: widget.topic.url,
//               ),
//             ),
//             Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => TopicPage(topic: widget.topic),
//                           ),
//                         );
//                       },
//                       child: AutoSizeText(
//                         'Learn words',
//                         style: Theme.of(context).textTheme.displaySmall,
//                         minFontSize: 10,
//                         maxFontSize: 15,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }
