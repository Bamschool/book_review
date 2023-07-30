import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:review_book/src/common/components/Input_widget.dart';
import 'package:review_book/src/common/components/app_font.dart';

import '../../common/cubit/authentication_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Container(
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
              return Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: state.user?.profile == null
                        ? Image.asset('assets/images/default_avatar.png').image
                        : Image.network(state.user!.profile!).image,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppFonts(
                    text: state.user?.name ?? '',
                    size: 16,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            InputWidget(
              isEnabled: false,
              onTap: () {
                context.push('/search');
              },
            ),
          ],
        ),
      ),
    );
  }
}
