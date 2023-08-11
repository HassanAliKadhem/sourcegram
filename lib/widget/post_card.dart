import 'package:flutter/material.dart';

import '../model/data.dart';
import '../model/post.dart';
import 'image_viewer.dart';
import '../screen/post_detail.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
  });
  final Post post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(
            height: 400,
            child: FutureBuilder<(List<Widget>, String)>(
              future: dataSource.getImagesAndReadMe(widget.post.fullName),
              builder: (context, snapshot) {
                if (widget.post.images.isNotEmpty && widget.post.readME.isNotEmpty) {
                  return ImageViewer(images: widget.post.images);
                } else if (snapshot.hasData) {
                  final (images, readME) = snapshot.data!;
                  widget.post.images = images;
                  widget.post.readME = readME;
                  return ImageViewer(images: widget.post.images);
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            isThreeLine: true,
            title: Text(
              widget.post.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  widget.post.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 8.0),
                Chip(
                    label: Text(
                  widget.post.language,
                  textScaleFactor: 0.8,
                )),
                const SizedBox(width: 8.0),
              ],
            ),
            trailing: Column(
              children: [
                const Icon(Icons.star),
                Text(widget.post.stars.toString()),
              ],
            ),
            leading: widget.post.avatar,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostDetailsScreen(post: widget.post))),
          ),
        ],
      ),
    );
  }
}
