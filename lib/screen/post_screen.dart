import 'package:flutter/material.dart';

import '../model/data.dart';
import '../model/post.dart';
import '../widget/post_card.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key, this.query, required this.queryText});
  final String? query;
  final String queryText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text("Search "),
              Chip(label: Text(queryText)),
            ],
          ),
        ),
        body: PostsScreen(
          query: query,
        ));
  }
}

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key, this.query});
  final String? query;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: query == null
          ? dataSource.getTodayPosts()
          : dataSource.getQueryPosts(query!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return PostCard(post: snapshot.data![index]);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}

