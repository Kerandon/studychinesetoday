enum FlashcardDisplay {
  englishFirst,
  chineseFirstWithPinyin,
  chineseFirstWithoutPinyin,
  audioOnly
}

extension AsText on FlashcardDisplay{

  String toText() {
    switch (this) {
      case FlashcardDisplay.englishFirst:
        return 'English First';
      case FlashcardDisplay.chineseFirstWithPinyin:
        return 'Chinese First with Pinyin';
      case FlashcardDisplay.chineseFirstWithoutPinyin:
        return 'Chinese First without Pinyin';
      case FlashcardDisplay.audioOnly:
        return 'Audio Only';
    }
  }


}