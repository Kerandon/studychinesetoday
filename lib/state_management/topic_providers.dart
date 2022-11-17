import 'package:riverpod/riverpod.dart';
import '../models/topic.dart';

class TopicManager {
  final Set<Topic> topics;

  TopicManager({required this.topics});

  TopicManager copyWith({Set<Topic>? topics}) {
    return TopicManager(topics: topics ?? this.topics);
  }
}

class TopicNotifier extends StateNotifier<TopicManager> {
  TopicNotifier(TopicManager state) : super(state);

  addTopics({required Set<Topic> topics}) {
    for (var t in topics) {
      state = state.copyWith(topics: {...state.topics, t});
    }
  }
}

final topicProvider = StateNotifierProvider<TopicNotifier, TopicManager>(
  (ref) => TopicNotifier(
    TopicManager(
      topics: {},
    ),
  ),
);
