import 'package:equatable/equatable.dart';

class Topic extends Equatable {

  final String english;
  final String character;
  final String pinyin;
  final String? url;

  const Topic({required this.english, required this.character, required this.pinyin, this.url});

  @override
  List<Object> get props => [english];

}