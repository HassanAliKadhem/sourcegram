import 'package:flutter/material.dart';

import 'model/data.dart';

import 'screen/post_screen.dart';
import 'screen/search_screen.dart';
import 'screen/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: config,
        child: const HomePage(),
        builder: (context, child) {
          Brightness brightness = <ThemeMode, Brightness>{
            ThemeMode.system: MediaQuery.of(context).platformBrightness,
            ThemeMode.dark: Brightness.dark,
            ThemeMode.light: Brightness.light,
          }[config.themeMode]!;
          return MaterialApp(
            title: 'SourceGram',
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.deepOrange,
                  brightness: brightness,
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 2,
                  scrolledUnderElevation: 2,
                ),
                chipTheme: ChipThemeData(
                  backgroundColor: brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  side: BorderSide.none,
                )),
            home: child,
          );
        });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _homePages = const [
    PostsScreen(key: ValueKey("home")),
    SearchScreen(),
    SettingsScreen(),
  ];

  final List<String> _homeTitles = const ['SourceGram', "Search", "Settings"];

  int _selectedHome = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_homeTitles[_selectedHome]),
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
        duration: const Duration(milliseconds: 250),
        child: _homePages[_selectedHome],
      ),
    );
  }
}
