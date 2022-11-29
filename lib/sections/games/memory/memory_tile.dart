import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/flip_animation.dart';
import 'package:studychinesetoday/configs/constants.dart';
import 'package:studychinesetoday/utils/enums/flip_stage.dart';
import 'package:studychinesetoday/sections/games/memory/memory_provider.dart';

import '../../../configs/app_colors.dart';
import 'memory_word.dart';

class MemoryTile extends ConsumerStatefulWidget {
  const MemoryTile({
    super.key,
    required this.memoryWord,
  });

  final MapEntry<int, MemoryModel> memoryWord;

  @override
  ConsumerState<MemoryTile> createState() => _MemoryTileState();
}

class _MemoryTileState extends ConsumerState<MemoryTile> {
  @override
  Widget build(BuildContext context) {
    final memoryState = ref.watch(memoryProvider);
    final memoryNotifier = ref.read(memoryProvider.notifier);

    MapEntry<int, MemoryModel> word = memoryState.memoryWords.entries
        .firstWhere((element) => element.key == widget.memoryWord.key);

    bool forwardFlip = false;
    bool reverseFlip = false;

    if (memoryState.canFlip &&
        !memoryState.answeredCorrectly.contains(word.key)) {
      if (memoryState.tappedWords.isNotEmpty &&
          memoryState.tappedWords.keys.last == word.key) {
        if (!memoryState.reverseFlip) {
          forwardFlip = true;
        }
      }
      if (memoryState.reverseFlip) {
        reverseFlip = true;
      }
    }
    return IgnorePointer(
      ignoring: memoryState.ignoreTaps ||
          memoryState.tappedWords.containsKey(word.key) ||
          memoryState.answeredCorrectly.contains(word.key),
      child: FlipAnimation(
        animate: forwardFlip,
        reverseFlip: reverseFlip,
        delay: reverseFlip ? 1000 : 0,
        duration: 1000,
        flipCallback: (flipStage) {
          WidgetsBinding.instance.addPostFrameCallback(
            (timeStamp) {

              if (flipStage == FlipStage.halfForward) {
                memoryNotifier.onHalfFlip(memoryWord: word, isForward: true);
              }
              if (flipStage == FlipStage.full) {
                memoryNotifier.onFullFlip(memoryWord: word);
              }
              if (flipStage == FlipStage.halfBack) {
                memoryNotifier.onHalfFlip(memoryWord: word, isForward: false);
              }
              if (flipStage == FlipStage.reverseCompleted) {
                memoryNotifier.onReverseFlip();
              }
            },
          );
        },
        child: GestureDetector(
          onTap: () {
            memoryNotifier.tileTapped(memoryWord: word);
          },
          child: Stack(
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(word.value.flipCard ? pi : 0),
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
                opacity: word.value.flipCard || memoryState.answeredCorrectly.contains(word.key) ? 0 : 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.red,
                    borderRadius: BorderRadius.circular(kRadius),
                  ),
                  child: const Center(
                    child: Icon(Icons.question_mark_outlined),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
