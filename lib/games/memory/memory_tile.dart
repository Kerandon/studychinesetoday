import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'memory_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('tapped ${widget.memoryWord.index}');
      },
      child: Container(
        color: Colors.red,
        child: Column(
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
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: LinearProgressIndicator(
                      value: downloadProgress.progress,
                    )),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
