import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';
import 'package:studychinesetoday/utils/methods_other.dart';
import '../providers/sentence_scrambler_manager.dart';
import 'letter_block_contents.dart';

class LetterBlock extends ConsumerStatefulWidget {
  const LetterBlock({
    super.key,
    required this.sentenceWord,
    required this.index,
    this.neverHideUI = false,
  });

  final SentenceWord sentenceWord;
  final int index;
  final bool neverHideUI;

  @override
  ConsumerState<LetterBlock> createState() => _LetterBlockState();
}

class _LetterBlockState extends ConsumerState<LetterBlock> {
  final _widgetKey = GlobalKey();
  Size _size = const Size(0, 0);
  Offset _originalPosition = const Offset(0, 0);
  bool _isPlaced = false;
  bool _hideChildUI = false;
  bool _haveSetUp = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);

    _getSizeAndPosition(notifier);

    SentenceWord? sentenceWord;
    for (var w in state.currentSentence) {
      if (w.correctPosition == widget.sentenceWord.correctPosition) {
        sentenceWord = w;
      }
    }

    _isPlaced = sentenceWord!.placedPosition != null;
    _hideChildUI = sentenceWord.hideChildUI;

    return _isPlaced || _hideChildUI
        ? SizedBox(
            width: _size.width,
            height: _size.height,
          )
        : IgnorePointer(
            key: _widgetKey,
            ignoring: false,
            child: Draggable<SentenceWord>(
              data: widget.sentenceWord,
              feedback: LetterBlockContents(
                wordData: widget.sentenceWord.wordData,
                addShadow: true,
              ),
              onDragEnd: (details) {
                if (!details.wasAccepted) {
                  notifier.blockDragCanceled(
                    sentenceWord: widget.sentenceWord,
                    droppedOffset: details.offset,
                  );
                      notifier.recallDroppedWord(recall: true);
                }
              },
              childWhenDragging: LetterBlockContents(
                wordData: widget.sentenceWord.wordData,
                hideUI: true,
              ),
              child: LetterBlockContents(
                wordData: widget.sentenceWord.wordData,
                hideUI: false,
                addShadow: false,
              ),
            ),
          );
  }

  void _getSizeAndPosition(SentenceScramblerNotifier notifier) {
    if (!_haveSetUp) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _size = getWidgetSize(key: _widgetKey);
        _originalPosition = getWidgetGlobalPosition(positionKey: _widgetKey);
        notifier.setBlockOriginalPosition(
            sentenceWord: widget.sentenceWord,
            offsetPosition: _originalPosition);
        _haveSetUp = true;
      });
    }
  }
}
