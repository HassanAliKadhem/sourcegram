import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'search_screen.dart';
import '../model/post.dart';
import '../util/launch_uri.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key, required this.post});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.fullName),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ListTile(
              title: Text(post.description),
              leading: post.avatar,
              trailing: Column(
                children: [
                  const Icon(Icons.star),
                  Text(post.stars.toString()),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.from([
                  const Text(" Language:  "),
                  ActionChip(
                    label: Text(post.language, textScaleFactor: 0.8),
                    onPressed: () => showSearchResults(context, post.language),
                  ),
                  if (post.topics.isNotEmpty) const Text("  Topics: "),
                ])
                  ..addAll(post.topics.map((e) => Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ActionChip(
                            label: Text(e, textScaleFactor: 0.8),
                            onPressed: () => showSearchResults(context, e)),
                      ))),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SelectionArea(
              child: post.readME == ""
                  ? Text(post.description)
                  : Markdown(
                    shrinkWrap: true,
                      data: post.readME,
                      selectable: true,
                      onTapLink: (text, href, title) {
                        if (href != null) {
                          launchUri(Uri.parse(href));
                        }
                      },
                      imageBuilder: (uri, title, alt) => Image.network(
                        uri.toString(),
                        errorBuilder: (context, error, stackTrace) =>
                            SvgPicture.network(uri.toString()),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
