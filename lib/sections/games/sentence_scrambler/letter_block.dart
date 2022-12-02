import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/sentence_scrambler_provider.dart';
import 'package:studychinesetoday/utils/methods_other.dart';
import '../../../models/word_data.dart';
import 'letter_block_contents.dart';

class LetterBlock extends ConsumerStatefulWidget {
  const LetterBlock({
    super.key,
    required this.wordData,
    required this.index,
    this.neverHideUI = false,
  });

  final WordData wordData;
  final int index;
  final bool neverHideUI;

  @override
  ConsumerState<LetterBlock> createState() => _LetterBlockState();
}

class _LetterBlockState extends ConsumerState<LetterBlock> {
  final _positionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final sentenceScramblerState = ref.watch(sentenceScramblerProvider);

    return IgnorePointer(
      ignoring: sentenceScramblerState.isAnimatingBackToPosition,
      child: Draggable<WordData>(
        data: widget.wordData,
        feedback: LetterBlockContents(
          wordData: widget.wordData,
          addShadow: true,
        ),
        onDragEnd: (details) {
          ref.read(sentenceScramblerProvider.notifier).animateBackToPosition(
                originalPosition:
                    getWidgetsGlobalPosition(positionKey: _positionKey),
                droppedPosition: details.offset,
                animate: true,
                letterBlock: LetterBlock(
                  wordData: widget.wordData,
                  index: widget.index,
                  neverHideUI: true,
                ),
              );
        },
        childWhenDragging: LetterBlockContents(
          key: _positionKey,
          wordData: widget.wordData,
          hideUI: true,
        ),
        child: LetterBlockContents(
            wordData: widget.wordData,
            hideUI: sentenceScramblerState.letterBlock.index == widget.index &&
                sentenceScramblerState.isAnimatingBackToPosition &&
                !widget.neverHideUI),
      ),
    );
  }
}
