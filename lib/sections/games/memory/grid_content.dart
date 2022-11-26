import 'package:flutter/material.dart';
import 'memory_tile.dart';
import 'memory_word.dart';

class GridContent extends StatefulWidget {
  const GridContent({Key? key, required this.memoryWords}) : super(key: key);

  final Map<int, MemoryWord> memoryWords;

  @override
  State<GridContent> createState() => _GridContentState();
}

class _GridContentState extends State<GridContent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
          size.width * 0.30, size.height * 0.05, size.width * 0.30, 0),
      itemCount: 36,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, mainAxisSpacing: 6, crossAxisSpacing: 6),
      itemBuilder: (context, index) => MemoryTile(
        memoryWord: widget.memoryWords.entries.elementAt(index)
      ),
    );
  }
}
