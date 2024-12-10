part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSignUp extends AuthState {}

final class AuthLoggedIn extends AuthState {
  final UserModel userModel;

  AuthLoggedIn(this.userModel);
}

final class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}
