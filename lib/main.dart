import 'package:flutter/material.dart';

import 'model/data.dart';

import 'screen/post_screen.dart';
import 'screen/search_screen.dart';
import 'screen/settings_screen.dart';

void main() {
  runApp(
    Data(
      dataSource: GithubData(),
      child: Config(
        notifier: AppConfig(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SourceGram',
      themeMode: Config.of(context).themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          scrolledUnderElevation: 2,
        ),
        chipTheme: ChipThemeData(
          side: BorderSide(color: Colors.grey.shade400),
          iconTheme: IconThemeData(color: Colors.grey.shade800),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          scrolledUnderElevation: 2,
        ),
        chipTheme: ChipThemeData(
          side: BorderSide(color: Colors.grey.shade800),
          iconTheme: IconThemeData(color: Colors.grey.shade300),
        ),
      ),
      home: const HomePage(),
    );
  }
}

const List<Widget> _homePages = [
  PostsScreen(),
  SearchScreen(),
  SettingsScreen(),
];

const List<String> _homeTitles = [
  "SourceGram",
  "Search",
  "Settings",
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedHome = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(_homeTitles[_selectedHome]),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedHome,
        onDestinationSelected: (value) {
          setState(() {
            _selectedHome = value;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
            tooltip: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: "Search",
            tooltip: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings",
            tooltip: "Settings",
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _homePages[_selectedHome],
      ),
    );
  }
}
