import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/pages/topic_page.dart';
import 'package:studychinesetoday/state_management/topic_providers.dart';
import 'package:studychinesetoday/utils/methods.dart';

import '../../configs/app_colors.dart';
import '../../configs/constants.dart';
import '../../models/topic.dart';

class TopicThumbnail extends ConsumerWidget {
  const TopicThumbnail({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadius),
            color: AppColors.offWhite,
            boxShadow: const [kShadow]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 1),
              child: Text(
                topic.english,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(overflow: TextOverflow.ellipsis),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${topic.character} ',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.grey, overflow: TextOverflow.ellipsis),
                  ),
                  Text(
                    ' ${topic.pinyin}',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.grey, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: DisplayImage(
                imageFuture: getThumbnailURL(topic: topic),
                returnedURL: (url) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    ref.read(topicProvider.notifier).addTopics(topics: {topic});
                  });
                },
               cachedURL: topic.url,
              ),
            ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TopicPage(topic: topic),
                          ),
                        );
                      },
                      child: AutoSizeText(
                        'Learn words',
                        style: Theme.of(context).textTheme.displaySmall,
                        minFontSize: 10,
                        maxFontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class DisplayImage extends ConsumerWidget {
  const DisplayImage({
    super.key,
    required this.imageFuture,
    required this.returnedURL,
    this.cachedURL,
  });

  final Future imageFuture;
  final Function(dynamic) returnedURL;
  final String? cachedURL;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: cachedURL == null
            ? FutureBuilder(
                future: imageFuture,
                //getThumbnailURL(topic: topic),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Expanded(child: Text('error ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    returnedURL.call(snapshot.data);
                    return BuildImage(url: snapshot.data);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : BuildImage(url: cachedURL!));
  }
}

class BuildImage extends StatelessWidget {
  const BuildImage({required this.url, Key? key}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(url);
  }
}
