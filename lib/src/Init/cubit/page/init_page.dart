import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_book/src/Init/cubit/init_cubit.dart';
import 'package:review_book/src/common/components/btn.dart';

import '../../../common/components/app_font.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/splash_bg.png",
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 40,
          right: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppFonts(
                text: "도서 리뷰 앱으로\n좋아하는 책을 찾아보세요",
                textAlign: TextAlign.center,
                color: Colors.white,
                size: 28,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),
              const AppFonts(
                text: "책리뷰에서 솔직하고 통찰력이 있는 리뷰를 받아보세요.",
                textAlign: TextAlign.center,
                color: Color(0xff878787),
                size: 13,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(
                height: 40,
              ),
              Btn(
                onTap: context.read<InitCubit>().startApp,
                text: "시작하기",
              ),
              const SizedBox(
                height: 40,
              ),
              // CircularProgressIndicator(),
            ],
          ),
        ),
      ],
    ));
  }
}
