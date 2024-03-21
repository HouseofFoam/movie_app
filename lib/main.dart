import 'package:flutter/material.dart';
import 'package:movie_app/pages/detail.dart';
import 'package:movie_app/pages/home.dart';
import 'package:movie_app/pages/search.dart';
import 'package:movie_app/route_arguments/detail_arguments.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      initialRoute: Home.route,
      routes: {
        Home.route: (context) => const Home(),
        DetailPage.route: (context) => DetailPage(
            detailArguments:
                ModalRoute.of(context)?.settings.arguments as DetailArguments),
        SearchPage.route: (context) => const SearchPage()
      },
    );
  }
}
