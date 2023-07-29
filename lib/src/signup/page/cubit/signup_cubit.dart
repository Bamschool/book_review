import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:review_book/src/common/model/user_model.dart';
import 'package:review_book/src/common/repository/user_repository.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final UserRepository _userRepository;
  SignUpCubit(
    UserModel userModel,
    this._userRepository,
  ) : super(SignUpState(userModel: userModel));

  void changeProfileImage(XFile? image) {
    if (image == null) return;
    var file = File(image.path);
    emit(state.copyWith(profileFile: file));
  }

  void changeNickName(String nickname) {
    emit(state.copyWith(nickname: nickname));
  }

  void changeDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateProfileImageUrl(String url) {
    emit(
      state.copyWith(
        status: SignUpStatus.loading,
        userModel: state.userModel!.copyWith(profile: url),
      ),
    );
    submit();
  }

  void uploadPercent(String percent) {
    emit(
      state.copyWith(percent: percent),
    );
  }

  void save() {
    if (state.nickname == null || state.nickname == '') return;
    emit(state.copyWith(status: SignUpStatus.loading));
    if (state.profileFile != null) {
      emit(state.copyWith(status: SignUpStatus.uploading));
    } else {
      submit();
    }
    print(state);
  }

  void submit() async {
    var joinUserModel = state.userModel!.copyWith(
      name: state.nickname,
      description: state.description,
    );
    var result = await _userRepository.joinUser(joinUserModel);
    if (result) {
      emit(
        state.copyWith(
          status: SignUpStatus.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: SignUpStatus.failed,
        ),
      );
      //todo 오류 메시
      //지
    }
  }
}

enum SignUpStatus {
  init,
  loading,
  success,
  failed,
  uploading,
}

class SignUpState extends Equatable {
  final File? profileFile;
  final String? nickname;
  final String? percent;
  final String? description;
  final SignUpStatus status;
  final UserModel? userModel;
  const SignUpState({
    this.profileFile,
    this.nickname,
    this.percent,
    this.description,
    this.status = SignUpStatus.init,
    this.userModel,
  });

  @override
  List<Object?> get props {
    return [
      profileFile,
      nickname,
      percent,
      description,
      status,
      userModel,
    ];
  }

  SignUpState copyWith({
    File? profileFile,
    String? nickname,
    String? percent,
    String? description,
    SignUpStatus? status,
    UserModel? userModel,
  }) {
    return SignUpState(
      profileFile: profileFile ?? this.profileFile,
      nickname: nickname ?? this.nickname,
      percent: percent ?? this.percent,
      description: description ?? this.description,
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  String toString() {
    return 'SignUpState(profileFile: $profileFile, nickname: $nickname, percent: $percent, description: $description, status: $status, userModel: $userModel)';
  }
}
