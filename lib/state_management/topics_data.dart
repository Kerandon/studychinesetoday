import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/models/topic_data.dart';

class TopicsDataState {
  final Set<TopicData> allTopicsData;

  TopicsDataState({required this.allTopicsData});

  TopicsDataState copyWith({required Set<TopicData> allTopicsData}) {
    return TopicsDataState(allTopicsData: allTopicsData);
  }
}

class TopicDataNotifier extends StateNotifier<TopicsDataState> {
  TopicDataNotifier(TopicsDataState state) : super(state);

  void addAllTopicsData({required Set<TopicData> allTopicsData}) {
    for (var t in allTopicsData) {
      state = state.copyWith(
          allTopicsData: {...state.allTopicsData, t});
    }
  }

  void addURL({required TopicData topicData, required String url}) {
    final topics = state.allTopicsData;
    final selectedTopic = topics.firstWhere((element) =>
    element.english == topicData.english);
    var updatedTopicData = TopicData(english: selectedTopic.english,
        character: selectedTopic.character,
        pinyin: selectedTopic.pinyin,
        words: selectedTopic.words,
        url: url
    );
    topics.remove(selectedTopic);
    topics.add(updatedTopicData);
  }
}

final topicsDataProvider =
StateNotifierProvider<TopicDataNotifier, TopicsDataState>(
      (ref) =>
      TopicDataNotifier(
        TopicsDataState(
          allTopicsData: {},
        ),
      ),
);
