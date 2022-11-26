import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/flip_animation.dart';
import 'package:studychinesetoday/configs/constants.dart';
import 'package:studychinesetoday/sections/games/memory/memory_provider.dart';

import '../../../configs/app_colors.dart';
import 'memory_word.dart';

class MemoryTile extends ConsumerStatefulWidget {
  const MemoryTile({
    super.key,
    required this.memoryWord,
  });

  final MapEntry<int, MemoryWord> memoryWord;

  @override
  ConsumerState<MemoryTile> createState() => _MemoryTileState();
}

class _MemoryTileState extends ConsumerState<MemoryTile> {
  @override
  Widget build(BuildContext context) {
    final memoryState = ref.watch(memoryProvider);
    final memoryNotifier = ref.read(memoryProvider.notifier);

    MapEntry<int, MemoryWord> word = memoryState.memoryWords.entries
        .firstWhere((element) => element.key == widget.memoryWord.key);

    return FlipAnimation(
      animate: word.value.isTapped,
      reverseFlip: false,
      index: 1,
      halfFlipCompleted: () {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            memoryNotifier.tileFlippedHalf(memoryWord: widget.memoryWord);
          },
        );
      },
      fullFlipCompleted: () {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {},
        );
      },
      child: GestureDetector(
        onTap: () {
          memoryNotifier.tileTapped(memoryWord: widget.memoryWord);
        },
        child: Stack(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(word.value.isHalfFlipped ? pi : 0),
              child: word.value.showChinese
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(kRadius),
                      ),
                      child: Center(child: Text(word.value.word.character)),
                    )
                  : Center(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(kRadius),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.memoryWord.value.word.url!,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: LinearProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
            ),
            Opacity(
              opacity: word.value.isHalfFlipped ? 0 : 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(kRadius),
                ),
                child: Center(
                  child: Icon(Icons.question_mark_outlined),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
