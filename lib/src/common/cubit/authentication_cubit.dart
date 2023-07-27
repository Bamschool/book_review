import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:review_book/src/common/model/user_model.dart';
import 'package:review_book/src/common/repository/authentication_repository.dart';
import 'package:review_book/src/common/repository/user_repository.dart';

class AuthenticationCubit extends Cubit<AuthenticationState>
    with ChangeNotifier {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  AuthenticationCubit(
    this._authenticationRepository,
    this._userRepository,
  ) : super(const AuthenticationState());

  void init() {
    _authenticationRepository.logout();
    _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      //로그아웃 상태
      emit(
        state.copyWith(
          status: AuthenticationStatus.unknown,
        ),
      );
    } else {
      var result = await _userRepository.findUserOne(user.uid!);
      if (result == null) {
        emit(
          state.copyWith(
            status: AuthenticationStatus.unAuthenticated,
          ),
        );
      }
      emit(
        state.copyWith(
          user: result,
          status: AuthenticationStatus.authentication,
        ),
      );

      //로그인 상태
    }

    notifyListeners();
  }

  void googleLogin() async {
    await _authenticationRepository.signInWithGoogle();
  }

  void appleLogin() async {
    await _authenticationRepository.signInWithApple();
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
}

enum AuthenticationStatus {
  authentication,
  unAuthenticated,
  unknown,
  init,
  error,
}

class AuthenticationState extends Equatable {
  final UserModel? user;
  final AuthenticationStatus status;
  const AuthenticationState({
    this.user,
    this.status = AuthenticationStatus.init,
  });
  @override
  List<Object?> get props => [
        status,
        user,
      ];

  AuthenticationState copyWith({
    UserModel? user,
    AuthenticationStatus? status,
  }) {
    return AuthenticationState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
