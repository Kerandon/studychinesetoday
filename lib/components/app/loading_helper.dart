import 'package:flutter/material.dart';

class LoadingHelper extends StatelessWidget {
  const LoadingHelper(
      {Key? key, required this.futures, required this.onFutureComplete})
      : super(key: key);

  final List<Future<dynamic>> futures;
  final Function(dynamic data) onFutureComplete;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(
        futures.toList()
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {

              onFutureComplete.call(snapshot.data!);
              Navigator.of(context).maybePop();


        }
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
