
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class DisplayImage extends ConsumerStatefulWidget {
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
  ConsumerState<DisplayImage> createState() => _DisplayImageState();
}

class _DisplayImageState extends ConsumerState<DisplayImage> {

 // late final _futureImage;

  @override
  void initState() {
    // _futureImage =
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: widget.cachedURL == null
            ? FutureBuilder(
          future: widget.imageFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Icon(Icons.person, size: 50, color: Colors.black12,);
            }
            if (snapshot.hasData) {
              widget.returnedURL.call(snapshot.data);
              return BuildImage(url: snapshot.data);
            }
            return const Center(child: CircularProgressIndicator());
          },
        )
            : BuildImage(url: widget.cachedURL!));
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
