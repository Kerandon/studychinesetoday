import '../../../../models/word_data.dart';
import '../grammatical_structures.dart';
import '../models/sentence.dart';

List<Sentence> sentences = [
  Sentence(
      wordDataList: [
        const WordData(english: '', character: "苹果", pinyin: ""),
        const WordData(english: '', character: "很", pinyin: ""),
        const WordData(english: '', character: "好吃", pinyin: ""),
      ],
      english: 'Apples are delicious',
      grammarStructure: grammaticalStructure_S_Adv_Adj),
  Sentence(
    wordDataList: [
      const WordData(english: "", character: "企鹅", pinyin: ""),
      const WordData(english: "", character: "很", pinyin: ""),
      const WordData(english: "", character: "可爱", pinyin: ""),
    ],
    english: 'Penguins are cute',
    grammarStructure: grammaticalStructure_S_Adv_Adj,
  ),
  Sentence(
      wordDataList: [
        const WordData(english: "", character: "把", pinyin: ""),
        const WordData(english: "", character: "勺子", pinyin: ""),
        const WordData(english: "", character: "给", pinyin: ""),
        const WordData(english: "", character: "我", pinyin: ""),
      ],
      english: 'Pass me the spoon',
      grammarStructure: grammaticalStructure_P_Obj_V_S)
];
