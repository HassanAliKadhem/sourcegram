import 'package:flutter/material.dart';

import 'post_screen.dart';

DateTime today = DateTime.now();
DateTime lastWeek = DateTime.now().subtract(const Duration(days: 7));
DateTime lastMonth = DateTime.now().subtract(const Duration(days: 31));

final Map<String, String> ages = {
  "Today":
      "created:<${today.year.toString()}-${today.month.toString().padLeft(2, "0")}-${today.day.toString().padLeft(2, "0")}",
  "Last Week":
      "created:<${lastWeek.year.toString()}-${lastWeek.month.toString().padLeft(2, "0")}-${lastWeek.day.toString().padLeft(2, "0")}",
  "Last Month":
      "created:<${lastMonth.year.toString()}-${lastMonth.month.toString().padLeft(2, "0")}-${lastMonth.day.toString().padLeft(2, "0")}",
};

const List<String> languages = [
  "Dart",
  "PHP",
  "Java",
  "JavaScript",
  "TypeScript",
  "HTML",
  "Python",
  "C#",
  "C++",
  "C",
  "Ruby",
  "Objective-C",
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          title: Text(
            "Age",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // const Divider(),
        Wrap(
          children: ages.keys
              .map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionChip(
                      avatar: const Icon(Icons.search),
                      label: Text(e),
                      onPressed: () => showSearchResults(context, e),
                    ),
                  ))
              .toList(),
        ),
        const ListTile(
          title: Text(
            "Languages",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // const Divider(),
        Wrap(
          children: languages
              .map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ActionChip(
                      avatar: const Icon(Icons.search),
                      label: Text(e),
                      onPressed: () => showSearchResults(context, e),
                    ),
                  ))
              .toList(),
        ),
        const ListTile(
          title: Text(
            "Manual Search",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        // const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    filled: true,
                  ),
                  onChanged: (value) => searchTerm = value,
                  onSubmitted: (value) => showSearchResults(context, value),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              IconButton.filledTonal(
                onPressed: () => showSearchResults(context, searchTerm),
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void showSearchResults(BuildContext context, String chipText) {
  String query = chipText;
  String queryText = chipText;
  if (languages.contains(chipText)) {
    query = "language:$chipText";
  } else if (ages.containsKey(chipText)) {
    query = ages[chipText]!;
  }
  // debugPrint(query);
  if (query.isNotEmpty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostsPage(query: query, queryText: queryText),
      ),
    );
  }
}
