import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'imsi/home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late GoRouter router;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    router = GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Home(),
      ),
      // GoRoute(
      //   path: '/detail',
      //   builder: (context, state) => const DetailPage(),
      // ),
    ], initialLocation: '/');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff1C1C1C),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xff1C1C1C),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
