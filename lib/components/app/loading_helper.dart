import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingHelper extends ConsumerWidget {
  const LoadingHelper(
      {Key? key, required this.future, required this.onFutureComplete})
      : super(key: key);

  final List<Future> future;
  final Function(List<dynamic>) onFutureComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait(
        future.toList()
      ),
      builder: (BuildContext context, dynamic snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            onFutureComplete.call(snapshot.data!);
          });
        }
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
