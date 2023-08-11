import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'post.dart';

DataSource dataSource = GithubData();

Config config = Config();

class Config extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode newMode) {
    _themeMode = newMode;
    notifyListeners();
  }
}

abstract class DataSource {
  Future<List<Post>> getTodayPosts();
  Future<List<Post>> getQueryPosts(String query);
  Future<(List<Widget>, String)> getImagesAndReadMe(String ownerRepo);
}

class SampleData implements DataSource {
  final List<Post> _postsCache = [];
  @override
  Future<List<Post>> getTodayPosts() async {
    if (_postsCache.isEmpty) {
      await Future.delayed(const Duration(seconds: 3));
      _postsCache.add(Post(
        name: "Test Application",
        fullName: "Test/Test Application",
        stars: 15,
        description: "Test description",
        language: "dart",
        avatar: Image.network("https://avatars.githubusercontent.com/u/958072?v=4"),
      ));
    }
    return _postsCache;
  }

  @override
  Future<List<Post>> getQueryPosts(String query) {
    return getTodayPosts();
  }

  @override
  Future<(List<Widget>, String)> getImagesAndReadMe(String ownerRepo) async {
    await Future.delayed(const Duration(seconds: 5));
    return const ([FlutterLogo(), FlutterLogo(), FlutterLogo()], "");
  }
}

class GithubData implements DataSource {
  final String searchBase = "https://api.github.com/search/repositories?q=";
  final String searchTail = "&sort=stars&per_page=20";

  final String imageBase = "https://raw.githubusercontent.com/";
  final List<String> imageTails = [
    "/master/README.md",
    "/main/README.md",
    "/master/Readme.md",
    "/main/Readme.md",
    "/master/readme.md",
    "/main/readme.md",
    "/master/README.rdoc",
    "/main/README.rdoc",
    "/master/README.markdown",
    "/main/README.markdown",
  ];

  final List<Post> _homePostsCache = [];
  final List<Post> _searchPostsCache = [];

  @override
  Future<List<Post>> getTodayPosts() async {
    if (_homePostsCache.isEmpty) {
      final response = await http.get(Uri.parse(
          "https://api.github.com/search/repositories?q=created:<${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, "0")}-${DateTime.now().day.toString().padLeft(2, "0")}&sort=stars&per_page=20"));
      if (response.statusCode == 200) {
        if (jsonDecode(response.body) case {"items": List items}) {
          for (var item in items) {
            _homePostsCache.add(Post.fromGithubJson(item));
          }
        }
      } else {
        throw FormatException(
            "${response.statusCode.toString()}: ${response.body}");
      }
    }
    return _homePostsCache;
  }

  @override
  Future<List<Post>> getQueryPosts(String query) async {
    _searchPostsCache.clear();
    final response = await http.get(Uri.parse(searchBase + query + searchTail));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) case {"items": List items}) {
        for (var item in items) {
          _searchPostsCache.add(Post.fromGithubJson(item));
        }
      }
    } else {
      throw FormatException(
          "${response.statusCode.toString()}: ${response.body}");
    }
    return _searchPostsCache;
  }

  @override
  Future<(List<Widget>, String)> getImagesAndReadMe(String ownerRepo) async {
    dynamic response;
    for (var tail in imageTails) {
      response = await http.get(Uri.parse(imageBase + ownerRepo + tail));
      if (response.statusCode == 200) {
        return (
          parseReadme(
              response.body, "$imageBase$ownerRepo/${tail.split("/")[1]}/"),
          response.body as String,
        );
      }
    }
    throw FormatException(response.body);
  }
}

RegExp imgTagRegex =
    // RegExp(r'(?<=!\[.*?]\().+?(?=[ \)])|(?<=<img src=").+?(?=")');
    // RegExp(r'(?<=!\[\D*?\]\().+?(?=[ \)])|(?<=<img src=").+?(?=")');
    RegExp(r'(?<=!\[[^\(]*?\]\().+?(?=[ \)])|(?<=<img src=").+?(?=")');

List<Widget> parseReadme(String readME, String base) {
  List<Widget> images = <Widget>[];
  Iterable<RegExpMatch> matches = imgTagRegex.allMatches(readME);
  for (final m in matches) {
    String current = m[0]!;
    if (!current.contains("/")) {
      current = base + current;
    }
    images.add(Image.network(
      current,
      errorBuilder: (context, error, stackTrace) => SvgPicture.network(current),
    ));
  }
  return images;
}
