import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/flip_animation.dart';
import 'package:studychinesetoday/sections/games/memory/memory_provider.dart';

import 'memory_word.dart';

class MemoryTile extends ConsumerStatefulWidget {
  const MemoryTile({
    super.key,
    required this.memoryWord,
  });

  final MemoryWord memoryWord;

  @override
  ConsumerState<MemoryTile> createState() => _MemoryTileState();
}

class _MemoryTileState extends ConsumerState<MemoryTile> {
  bool _isFlippedOver = false;

  @override
  Widget build(BuildContext context) {
    bool flipAround = false;
    final memoryState = ref.watch(memoryProvider);
    final memoryNotifier = ref.read(memoryProvider.notifier);

    if (memoryState.tappedMemoryWords.isNotEmpty) {
      if (memoryState.tappedMemoryWords.last.index == widget.memoryWord.index) {
        flipAround = true;
      }
    }

    return FlipAnimation(
      animate: flipAround,
      index: widget.memoryWord.index,
      halfFlipCompleted: () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          print(
              'half flip for ${widget.memoryWord.index} and ${widget.memoryWord.word.english}');
          _isFlippedOver = !_isFlippedOver;
          setState(() {});
        });
      },
      child: GestureDetector(
          onTap: () {
            memoryNotifier.tileTapped(memoryWord: widget.memoryWord);
            print('tapped ${widget.memoryWord.index}');
          },
          child: Container(
            color: Colors.red,
            child: Stack(
              children: [
                _isFlippedOver
                    ? SizedBox()
                    : Center(child: Icon(Icons.question_mark_outlined)),
                Opacity(
                  opacity: _isFlippedOver ? 1 : 0,
                  child: widget.memoryWord.showChinese
                      ? Center(child: Text(widget.memoryWord.word.character))
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CachedNetworkImage(
                              imageUrl: widget.memoryWord.word.url!,
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
              ],
            ),
          )),
    );
  }
}
