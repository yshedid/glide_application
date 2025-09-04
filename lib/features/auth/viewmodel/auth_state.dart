abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}

class RegisterSuccess extends AuthState {}

class RegisterFailure extends AuthState {
  final String errorMessage;
  RegisterFailure(this.errorMessage);
}

class LogoutSuccess extends AuthState {}

class LogoutFailure extends AuthState {
  final String errorMessage;
  LogoutFailure(this.errorMessage);
}
