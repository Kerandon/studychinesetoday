
import 'package:flutter/material.dart';

class DisplayImage extends ConsumerWidget {
  const DisplayImage({
    super.key,
    required this.imageFuture,
    required this.returnedURL,
    this.cachedURL,
  });

  final Future imageFuture;
  final Function(dynamic) returnedURL;
  final String? cachedURL;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: cachedURL == null
            ? FutureBuilder(
          future: imageFuture,
          //getThumbnailURL(topic: topic),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Icon(Icons.person, size: 50, color: Colors.black12,);
            }
            if (snapshot.hasData) {
              returnedURL.call(snapshot.data);
              return BuildImage(url: snapshot.data);
            }
            return const Center(child: CircularProgressIndicator());
          },
        )
            : BuildImage(url: cachedURL!));
  }
}

class BuildImage extends StatelessWidget {
  const BuildImage({required this.url, Key? key}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(url);
  }
}
