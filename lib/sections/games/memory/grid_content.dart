import 'package:flutter/material.dart';
import 'memory_tile.dart';
import 'memory_word.dart';

class GridContent extends StatefulWidget {
  const GridContent({Key? key, required this.memoryWords}) : super(key: key);

  final Map<int, MemoryModel> memoryWords;

  @override
  State<GridContent> createState() => _GridContentState();
}

class _GridContentState extends State<GridContent> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.80,
        height: size.height * 0.80,
        color: Colors.grey,
        child: Center(
          child: GridView.builder(
            padding: EdgeInsets.only(
                left: size.width * 0.20, right: size.width * 0.15),
            shrinkWrap: true,
            itemCount: 36,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (context, index) => MemoryTile(
                memoryWord: widget.memoryWords.entries.elementAt(index)),
          ),
        ),
      ),
    );
  }
}
