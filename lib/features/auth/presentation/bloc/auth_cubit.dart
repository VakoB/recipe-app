import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:recipe_app/features/user_profile/domain/repositories/user_profile_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final UserProfileRepository _userProfileRepository;
  StreamSubscription? _authSubscription;

  AuthCubit(this._authRepository, this._userProfileRepository)
    : super(const AuthInitial()) {
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
      );
      await _userProfileRepository.createProfile(
        UserProfile(
          uid: user.uid,
          username: username,
          email: email,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await _authRepository.login(email: email, password: password);
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
