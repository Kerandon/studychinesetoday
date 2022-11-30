import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../components/app/display_image.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_theme.dart';
import '../../models/topic_data.dart';
import '../../state_management/topics_data.dart';
import '../../utils/methods.dart';

class TopicTile extends ConsumerStatefulWidget {
  const TopicTile({
    super.key,
    required this.topicData,
  });

  final TopicData topicData;

  @override
  ConsumerState<TopicTile> createState() => _TopicTileState();
}

class _TopicTileState extends ConsumerState<TopicTile> {
  late final Future<String> _futureImage;

  @override
  void initState() {
    _futureImage = getRandomTopicURL(topic: widget.topicData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.height * 0.01),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: kBuildGreyBoxDecoration(
          color: AppColors.offWhite,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: DisplayImage(
                  imageFuture: _futureImage,
                  returnedURL: (url) {
                    ref
                        .read(topicsDataProvider.notifier)
                        .addURL(topicData: widget.topicData, url: url);
                  },
                  cachedURL: widget.topicData.url,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    widget.topicData.english,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    widget.topicData.character,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: AppColors.darkGrey),
                  ),
                  Text(
                    widget.topicData.pinyin,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: AppColors.darkGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
