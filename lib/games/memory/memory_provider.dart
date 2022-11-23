import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/word_data.dart';
import 'memory_word.dart';

class MemoryState {
  final Set<WordData> allSelectedWords;
  final Set<MemoryWord> memoryWords;
  final List<MemoryWord> tappedMemoryWords;

  MemoryState(
      {required this.allSelectedWords,
      required this.memoryWords,
      required this.tappedMemoryWords});

  MemoryState copyWith(
      {Set<WordData>? allSelectedWords,
      Set<MemoryWord>? memoryWords,
      List<MemoryWord>? tappedMemoryWords}) {
    return MemoryState(
      allSelectedWords: allSelectedWords ?? this.allSelectedWords,
      tappedMemoryWords: tappedMemoryWords ?? this.tappedMemoryWords,
      memoryWords: memoryWords ?? this.memoryWords,
    );
  }
}

class MemoryNotifier extends StateNotifier<MemoryState> {
  MemoryNotifier(MemoryState state) : super(state);

  addMemoryWords({required Set<MemoryWord> memoryWords}) {
    state = state.copyWith(memoryWords: memoryWords);
    for(var m in state.memoryWords){
      print('memory words tapped is ${m.index}');
    }
  }

  addTappedMemoryWord({required MemoryWord memoryWord}) {
    state = state
        .copyWith(tappedMemoryWords: [...state.tappedMemoryWords, memoryWord]);
  }
}

final memoryProvider = StateNotifierProvider<MemoryNotifier, MemoryState>(
  (ref) => MemoryNotifier(
    MemoryState(
      allSelectedWords: {},
      memoryWords: {},
      tappedMemoryWords: [],
    ),
  ),
);


