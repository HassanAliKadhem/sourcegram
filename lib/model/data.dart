import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'parse_readme.dart';
import 'post.dart';
import 'sample_data.dart';

class AppConfig extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode newMode) {
    _themeMode = newMode;
    notifyListeners();
  }
}

class Config extends InheritedNotifier<AppConfig> {
  const Config({super.key, super.notifier, required super.child});

  static AppConfig of(BuildContext context) {
    assert(context.dependOnInheritedWidgetOfExactType<Config>() != null,
        "Config is not found");
    return context.dependOnInheritedWidgetOfExactType<Config>()!.notifier!;
  }

  @override
  bool updateShouldNotify(covariant Config oldWidget) {
    return notifier != oldWidget.notifier;
  }
}

abstract class DataSource {
  Future<List<Post>> getTodayPosts({int page = 0});
  Future<List<Post>> getQueryPosts(String query, {int page = 0});
  Future<(List<Widget>, String)> getImagesAndReadMe(String ownerRepo);
}

class Data extends InheritedWidget {
  const Data({super.key, required this.dataSource, required super.child});

  final DataSource dataSource;

  static DataSource of(BuildContext context) {
    assert(context.dependOnInheritedWidgetOfExactType<Data>() != null,
        "Data is not found");
    return context.dependOnInheritedWidgetOfExactType<Data>()!.dataSource;
  }

  @override
  bool updateShouldNotify(covariant Data oldWidget) {
    return dataSource != oldWidget.dataSource;
  }
}

class SampleData implements DataSource {
  @override
  Future<List<Post>> getTodayPosts({int page = 1}) async {
    final List<Post> homePosts = [];
    if (jsonDecode(samplePosts) case {"items": List items}) {
      for (var item in items) {
        homePosts.add(Post.fromGithubJson(item));
      }
    }
    return homePosts.skip((page * 20) - 1).take(20).toList();
  }

  @override
  Future<List<Post>> getQueryPosts(String query, {int page = 1}) {
    return getTodayPosts(page: page);
  }

  @override
  Future<(List<Widget>, String)> getImagesAndReadMe(String ownerRepo) async {
    await Future.delayed(const Duration(seconds: 2));
    return (List.generate(30, (index) => const FlutterLogo()), "Test");
  }
}

class GithubData implements DataSource {
  final int postsPerPage = 20;

  final String searchBase = "https://api.github.com/search/repositories?q=";
  final String searchTail = "&sort=stars&per_page=";

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

  final String today =
      "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, "0")}-${DateTime.now().day.toString().padLeft(2, "0")}";
  final String lastWeek = "";

  @override
  Future<List<Post>> getTodayPosts({int page = 1}) async {
    final List<Post> homePosts = [];
    final response = await http.get(Uri.parse(
        "https://api.github.com/search/repositories?q=created:<$today&sort=stars&per_page=$postsPerPage&page=$page"));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) case {"items": List items}) {
        for (var item in items) {
          homePosts.add(Post.fromGithubJson(item));
        }
      }
    } else {
      throw FormatException(
          "${response.statusCode.toString()}: ${response.body}");
    }
    return homePosts;
  }

  @override
  Future<List<Post>> getQueryPosts(String query, {int page = 1}) async {
    final List<Post> searchPosts = [];
    final response = await http
        .get(Uri.parse("$searchBase$query$searchTail$postsPerPage&page=$page"));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) case {"items": List items}) {
        for (var item in items) {
          searchPosts.add(Post.fromGithubJson(item));
        }
      }
    } else {
      throw FormatException(
          "${response.statusCode.toString()}: ${response.body}");
    }
    return searchPosts;
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
