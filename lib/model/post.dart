import 'package:flutter/material.dart';

class Post {
  final String name;
  final String fullName;
  final int stars;
  final String description;
  final Image avatar;
  final String language;
  final List<String> topics;
  List<Widget> images;
  String readME;

  Post({
    required this.name,
    required this.fullName,
    required this.stars,
    required this.description,
    required this.language,
    required this.avatar,
    this.topics = const [],
    this.images = const [],
    this.readME = "",
  });

  factory Post.fromGithubJson(Map<String, dynamic> json) {
    return Post(
      name: json["name"]?? "",
      fullName: json["full_name"]?? "",
      stars: json["stargazers_count"]?? 0,
      description: json["description"]?? "",
      language: json["language"]?? "",
      topics: List<String>.from(json["topics"]),
      avatar: Image.network(json["owner"]["avatar_url"]?? ""),
    );
  }
}
