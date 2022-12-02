import 'package:flutter/material.dart';

import '../../../models/word_data.dart';

class DropZone extends StatelessWidget {
  const DropZone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    WordData? wordData;
    final size = MediaQuery.of(context).size;

    return DragTarget<WordData>(
      onWillAccept: (details) {
        return true;
      },
      onAccept: (details) {
        wordData = details;
      },
      builder: (context, _, __) {
        return wordData == null
            ? Container(
                width: size.width * 0.10,
                height: size.height * 0.05,
                color: Colors.amber,
              )
            : FittedBox(
              fit: BoxFit.contain,
              child: Container(
                height:  size.height * 0.05,
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      wordData!.english,
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  )),
            );
      },
    );
  }
}
