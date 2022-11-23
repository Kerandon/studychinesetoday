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

  addAllTopicsData({required Set<TopicData> allTopicsData}) {
    for (var t in allTopicsData) {
      state = state.copyWith(
          allTopicsData: {...state.allTopicsData, t});
    }
  }
}

final topicsDataProvider =
    StateNotifierProvider<TopicDataNotifier, TopicsDataState>(
  (ref) => TopicDataNotifier(
    TopicsDataState(
      allTopicsData: {},
    ),
  ),
);
