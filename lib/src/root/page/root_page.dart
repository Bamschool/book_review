import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_book/src/Init/cubit/init_cubit.dart';
import 'package:review_book/src/Init/cubit/page/init_page.dart';
import 'package:review_book/src/spalsh/page/splash_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitCubit, bool>(builder: (context, state) {
      return state ? const SplashPage() : const InitPage();
    });
  }
}
