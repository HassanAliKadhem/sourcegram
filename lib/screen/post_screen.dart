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

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key, this.query});
  final String? query;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final List<Post> posts = [];
  int page = 1;
  bool lastPage = false;

  void loadPosts() {
    if (widget.query == null) {
      dataSource.getTodayPosts(page: page).then((value) {
        setState(() {
          lastPage = value.isEmpty;
          posts.addAll(value);
        });
      });
    } else {
      dataSource.getQueryPosts(widget.query!, page: page).then((value) {
        setState(() {
          lastPage = value.isEmpty;
          posts.addAll(value);
        });
      });
    }
    page++;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   posts.clear();
  //   loadPosts();
  // }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(12.0),
        itemCount: !lastPage ? posts.length + 1 : posts.length,
        itemBuilder: (context, index) {
          if (index == posts.length && !lastPage) {
            loadPosts();
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return PostCard(post: posts[index]);
          }
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
      );
    } else {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}
