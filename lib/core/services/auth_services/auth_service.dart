import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final subaBaseClient = Supabase.instance.client;

  // Sign up a new user
  Future<void> signUp(String email, String password, String name) async {
    final response = await subaBaseClient.auth
        .signUp(email: email, password: password, data: {'name': name})
        .onError(
          (error, stackTrace) => throw Exception('Sign in failed: $error'),
        );
  }

  // Sign in an existing user
  signInWithEmailAndPassword(String email, String password) async {
    final response = await subaBaseClient.auth
        .signInWithPassword(email: email, password: password)
        .onError(
          (error, stackTrace) => throw Exception('Sign in failed: $error'),
        );
    return response;
  }

  // Sign out the current user
  Future<void> signOut() async {
    final response = await subaBaseClient.auth.signOut().onError(
      (error, stackTrace) => throw Exception('Sign in failed: $error'),
    );
  }

}
