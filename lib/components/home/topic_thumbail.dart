import 'package:flutter/material.dart';
import 'package:studychinesetoday/pages/topic_page.dart';
import 'package:studychinesetoday/utils/methods.dart';

import '../../configs/app_colors.dart';
import '../../configs/constants.dart';
import '../../models/topic.dart';

class TopicThumbnail extends StatelessWidget {
  const TopicThumbnail({
    super.key,
    required this.topic,
  });

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: size.width * 0.20,
        height: size.height * 0.10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadius),
            color: AppColors.offWhite,
            boxShadow: const [kShadow]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 1),
              child: FittedBox(
                child: Text(
                  topic.english,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            FittedBox(
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${topic.character} ',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.grey),
                    ),
                    Text(
                      ' ${topic.pinyin}',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.01),
                child: FutureBuilder(
                  future: getThumbnailURL(topic: topic),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Expanded(child: Text('error ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      return Image.network(snapshot.data!);
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
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
                      child: const FittedBox(
                        child: Text('Learn words'),
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
