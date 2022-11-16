import 'package:riverpod/riverpod.dart';
import '../models/topic.dart';

final allTopics = Provider<List<Topic>>((ref) {
  return [];
});
