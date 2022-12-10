import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/animations/fly_in_animation.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_block.dart';
import 'package:studychinesetoday/utils/methods_other.dart';
import '../../../../configs/constants_other.dart';
import '../providers/sentence_scrambler_manager.dart';
import 'letter_block_contents.dart';

class LetterBlock extends ConsumerStatefulWidget {
  const LetterBlock({
    super.key,
    required this.sentenceWord,
    required this.index,
    this.neverHideUI = false,
  });

  final SentenceBlock sentenceWord;
  final int index;
  final bool neverHideUI;

  @override
  ConsumerState<LetterBlock> createState() => _LetterBlockState();
}

class _LetterBlockState extends ConsumerState<LetterBlock> {
  final _widgetKey = GlobalKey();
  Offset _originalPosition = const Offset(0, 0);
  bool _isPlaced = false;
  bool _hideChildUI = false;
  bool _haveSetUp = false;
  bool _animateOnStart = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(sentenceScramblerProvider);
    final notifier = ref.read(sentenceScramblerProvider.notifier);

    _getSizeAndPosition(notifier);

    SentenceBlock? sentenceWord;
    for (var w in state.currentSentence) {
      if (w.correctPosition == widget.sentenceWord.correctPosition) {
        sentenceWord = w;
      }
    }

    _isPlaced = sentenceWord!.placedPosition != null;
    _hideChildUI = sentenceWord.hideChildUI;

    return _isPlaced || _hideChildUI
        ? SizedBox(
            width: size.width * kSentenceWordBlockWidth,
            height: size.height * kSentenceWordBlockHeight,
          )
        : IgnorePointer(
            key: _widgetKey,
            ignoring: false,
            child: Draggable<SentenceBlock>(
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
              child: FlyInAnimation(
                animateOnDemand: _animateOnStart,
                onAnimationComplete: () {
                  _animateOnStart = false;
                },
                child: LetterBlockContents(
                  wordData: widget.sentenceWord.wordData,
                  hideUI: false,
                  addShadow: false,
                ),
              ),
            ),
          );
  }

  void _getSizeAndPosition(SentenceScramblerNotifier notifier) {
    if (!_haveSetUp) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _originalPosition = getWidgetGlobalPosition(positionKey: _widgetKey);
        notifier.setBlockOriginalPosition(
            sentenceWord: widget.sentenceWord,
            offsetPosition: _originalPosition);
      });
      _haveSetUp = true;
    }
  }
}
