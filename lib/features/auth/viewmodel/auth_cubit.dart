import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/auth_services/auth_service.dart';
import '../../../core/services/profile_picture/profile_picture_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService = AuthService();
  String? currentUserName = '';

  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  // Sign up a new user
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());
    try {
      await authService.signUp(email, password, name);
      log("success");
      storeName();
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
      log("error${e.toString()}");
    }
  }

  // Sign in an existing user
  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      var response = await authService.signInWithEmailAndPassword(
        email,
        password,
      );
      storeName();
      emit(LoginSuccess());
      log("success ${response.user}");
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await authService.signOut();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
  Future<void> storeName() async {
    try {

      // Get current user name
       currentUserName = await ProfileService().getCurrentUser().then((value) => value[0]);

    } catch (e) {
      log('Error initializing profile: $e');
      currentUserName = 'Guest';

    }
  }

}
