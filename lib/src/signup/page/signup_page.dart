import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:review_book/src/common/components/app_font.dart';
import 'package:review_book/src/common/components/btn.dart';
import 'package:review_book/src/common/cubit/authentication_cubit.dart';
import 'package:review_book/src/common/cubit/upload_data_load.cubut.dart';
import 'package:review_book/src/signup/page/cubit/signup_cubit.dart';

import '../../common/components/loading.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  _signupView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
            child: GestureDetector(
              onTap: () {},
              child: SvgPicture.asset('assets/svg/icons/icon_close.svg'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _userProfileImageFiled(),
            const SizedBox(
              height: 50,
            ),
            const _NickNameField(),
            const SizedBox(
              height: 30,
            ),
            const _descriptionField(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20 + MediaQuery.of(context).padding.bottom,
          top: 20,
        ),
        child: Row(
          children: [
            Expanded(
              child: Btn(
                onTap: context.read<SignUpCubit>().save,
                text: "가입하기",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Btn(
                backgroundColor: const Color(0xff212121),
                onTap: () {},
                text: "취소",
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpCubit, SignUpState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case SignUpStatus.init:
                break;
              case SignUpStatus.loading:
                break;

              case SignUpStatus.uploading:
                context.read<UploadCubit>().uploadUserProfile(
                    state.profileFile!, state.userModel!.uid!);

              case SignUpStatus.success:
                context.read<AuthenticationCubit>().reLoad();
                break;

              case SignUpStatus.failed:
                break;
            }
          },
        ),
        BlocListener<UploadCubit, UploadState>(
          listener: (context, state) {
            switch (state.status) {
              case UploadStatus.init:
                break;
              case UploadStatus.uploading:
                context
                    .read<SignUpCubit>()
                    .uploadPercent(state.percent!.toStringAsFixed(2));
                break;
              case UploadStatus.success:
                context.read<SignUpCubit>().updateProfileImageUrl(state.url!);
              case UploadStatus.fail:
                break;
            }
          },
        ),
      ],
      child: Stack(
        children: [
          _signupView(context),
          BlocBuilder<SignUpCubit, SignUpState>(
              buildWhen: (previous, current) =>
                  previous.percent != current.percent ||
                  previous.status != current.status,
              builder: (context, state) {
                if (state.percent != null &&
                    state.status == SignUpStatus.uploading) {
                  return Loading(loadingMessage: '${state.percent}%');
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}

class _userProfileImageFiled extends StatelessWidget {
  _userProfileImageFiled();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var profileFile =
        context.select<SignUpCubit, File?>((cubit) => cubit.state.profileFile);
    return Center(
      child: GestureDetector(
        onTap: () async {
          var image = await _picker.pickImage(source: ImageSource.gallery);
          context.read<SignUpCubit>().changeProfileImage(image);
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 50,
          backgroundImage: profileFile == null
              ? Image.asset('assets/images/default_avatar.png').image
              : Image.file(profileFile).image,
        ),
      ),
    );
  }
}

class _NickNameField extends StatelessWidget {
  const _NickNameField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppFonts(
          text: "닉네임",
          size: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          onChanged: context.read<SignUpCubit>().changeNickName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff232323),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                gapPadding: 0,
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                gapPadding: 0,
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}

class _descriptionField extends StatelessWidget {
  const _descriptionField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppFonts(
          text: "한 줄 소개",
          size: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          onChanged: context.read<SignUpCubit>().changeDescription,
          maxLength: 50,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            counterStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            fillColor: const Color(0xff232323),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                gapPadding: 0,
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                gapPadding: 0,
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
