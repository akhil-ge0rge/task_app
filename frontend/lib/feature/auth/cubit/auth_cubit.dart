import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/services/shared_preferences.dart';
import 'package:frontend/feature/auth/repository/auth_local_repository.dart';
import 'package:frontend/feature/auth/repository/auth_remote_repository.dart';

import '../../../model/user_model.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authRemoteRepository = AuthRemoteRepository();
  final spServices = SpServices();
  final authLocalRepository = AuthLocalRepository();

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      await authRemoteRepository.signUp(
          name: name, email: email, password: password);
      emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final user =
          await authRemoteRepository.login(email: email, password: password);
      if (user.token.isNotEmpty) {
        await spServices.setToken(user.token);
      }
      await authLocalRepository.insertUser(user);
      emit(AuthLoggedIn(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void getUser() async {
    try {
      emit(AuthLoading());
      final user = await authRemoteRepository.getUser();

      if (user != null) {
        await authLocalRepository.insertUser(user);
        emit(AuthLoggedIn(user));
        return;
      }
      emit(AuthInitial());
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
