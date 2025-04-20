import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/a11y-dark.dart';
import 'package:share_plus/share_plus.dart';

import 'search_screen.dart';
import '../model/data.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.share(post.fullName, subject: post.fullName),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.list(children: [
            ListTile(
              title: SelectableText(post.description),
              leading: post.avatar,
              trailing: Column(
                children: [
                  const Icon(Icons.star),
                  Text(post.stars.toString()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: List.from([
                  const Text(" Language:  "),
                  ActionChip(
                    label: Text(
                      post.language,
                      textScaler: const TextScaler.linear(0.8),
                    ),
                    onPressed: () => showSearchResults(context, post.language),
                  ),
                  if (post.topics.isNotEmpty) const Text("  Topics: "),
                ])
                  ..addAll(post.topics.map((e) => Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ActionChip(
                            label: Text(
                              e,
                              textScaler: const TextScaler.linear(0.8),
                            ),
                            onPressed: () => showSearchResults(context, e)),
                      ))),
              ),
            ),
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            post.readME == ""
                ? Text(post.description)
                : MarkdownWidget(
                    data: post.readME,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    selectable: true,
                    padding: const EdgeInsets.all(8.0),
                    config: MarkdownConfig(configs: [
                      PreConfig(
                        theme: Config.of(context).themeMode == ThemeMode.light
                            ? a11yLightTheme
                            : a11yDarkTheme,
                      ),
                      LinkConfig(
                        onTap: (value) {
                          launchUri(Uri.parse(value));
                        },
                      ),
                    ]),
                    // imageBuilder: (uri, title, alt) => Image.network(
                    //   uri.toString(),
                    //   errorBuilder: (context, error, stackTrace) =>
                    //       SvgPicture.network(uri.toString()),
                    // ),
                  ),
          ]),
        ],
      ),
    );
  }
}
