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

    if(memoryState.tappedMemoryWords.isNotEmpty) {
      if (memoryState.tappedMemoryWords.last.index == widget.memoryWord.index) {
        flipAround = true;
        _isFlippedOver = !_isFlippedOver;
      }
    }


    return FlipAnimation(
      animate: flipAround,
      index: widget.memoryWord.index,
      halfFlipCompleted: (){
        print('half flip for ${widget.memoryWord.index} and ${widget.memoryWord.word.english}');
      },
      child: GestureDetector(
        onTap: () {
          memoryNotifier.tileTapped(memoryWord: widget.memoryWord);
          print('tapped ${widget.memoryWord.index}');
        },
        child: Container(
          color: Colors.red,
          child: _isFlippedOver ? Container(color: Colors.blue) : Column(
            children: [
              if (widget.memoryWord.showChinese) ...[
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        (widget.memoryWord.word.character),
                      ),
                      Text(
                        (widget.memoryWord.word.english),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: widget.memoryWord.word.url!,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: LinearProgressIndicator(
                        value: downloadProgress.progress,
                      )),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
