import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:review_book/src/common/cubit/authentication_cubit.dart';
import 'package:review_book/src/common/repository/user_repository.dart';
import 'package:review_book/src/home/page/home_page.dart';
import 'package:review_book/src/root/page/root_page.dart';
import 'package:review_book/src/signup/page/cubit/signup_cubit.dart';
import 'package:review_book/src/signup/page/signup_page.dart';

import 'login/pages/login_page.dart';

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
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: context.read<AuthenticationCubit>(),
      redirect: (context, state) {
        var authStatus = context.read<AuthenticationCubit>().state.status;
        switch (authStatus) {
          case AuthenticationStatus.authentication:
            return '/home';
          case AuthenticationStatus.unAuthenticated:
            return '/signup';
          case AuthenticationStatus.error:
            break;
          case AuthenticationStatus.unknown:
            return '/login';
          case AuthenticationStatus.init:
            break;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const RootPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => BlocProvider(
            create: (context) => SignUpCubit(
                context.read<AuthenticationCubit>().state.user!,
                context.read<UserRepository>()),
            child: const SignUpPage(),
          ),
        ),
        // GoRoute(
        //   path: '/init',
        //   builder: (context, state) => const InitPage(),
        // ),
        // GoRoute(
        //   path: '/detail',
        //   builder: (context, state) => const DetailPage(),
        // ),
      ],
    );
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
