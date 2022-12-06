import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/models/sentence_word.dart';
import 'package:studychinesetoday/sections/games/sentence_scrambler/providers/sentence_scrambler_animation.dart';
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
  Size _size = Size(0, 0);
  bool _isPlaced = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _size = getSize(key: _widgetKey);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final animationState = ref.watch(sentenceAnimationProvider);
    final managerState = ref.watch(sentenceScramblerProvider);
    final managerNotifier = ref.read(sentenceScramblerProvider.notifier);

    SentenceWord? sentenceWord;
    for (var w in managerState.currentSentence) {
      if (w.position == widget.sentenceWord.position) {
        sentenceWord = w;
      }
    }

    _isPlaced = sentenceWord?.isPlaced ?? false;

    return _isPlaced
        ? SizedBox(
            width: _size.width,
            height: _size.height,
          )
        : IgnorePointer(
            key: _widgetKey,
            ignoring: animationState.isAnimatingBackToPosition,
            child: Draggable<SentenceWord>(
              data: widget.sentenceWord,
              feedback: LetterBlockContents(
                wordData: widget.sentenceWord.wordData,
                addShadow: true,
              ),
              onDragEnd: (details) {
                if (details.wasAccepted) {
                  managerNotifier.wordAccepted(
                      sentenceWord: widget.sentenceWord);
                } else {
                  ref
                      .read(sentenceAnimationProvider.notifier)
                      .animateBackToPosition(
                        originalPosition:
                            getWidgetsGlobalPosition(positionKey: _widgetKey),
                        droppedPosition: details.offset,
                        animate: true,
                        letterBlock: LetterBlock(
                          sentenceWord: widget.sentenceWord,
                          index: widget.index,
                          neverHideUI: true,
                        ),
                      );
                }
              },
              childWhenDragging: LetterBlockContents(
                wordData: widget.sentenceWord.wordData,
                hideUI: true,
              ),
              child: LetterBlockContents(
                wordData: widget.sentenceWord.wordData,
                hideUI: animationState.letterBlock.index == widget.index &&
                    animationState.isAnimatingBackToPosition &&
                    !widget.neverHideUI,
                addShadow: false,
              ),
            ),
          );
  }
}

Size getSize({required GlobalKey key}) {
  if (key.currentContext != null) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size;
  } else {
    return const Size(0, 0);
  }
}
