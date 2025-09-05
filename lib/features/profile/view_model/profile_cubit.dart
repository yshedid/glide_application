import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/features/profile/view_model/profile_states.dart';

import '../../../core/services/profile_picture/profile_picture_service.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  final ProfileService _profileService = ProfileService();

  // Store current user data
  String? _currentUserName;
  String? date;
  String? currentAvatarUrl;

  // Getters for accessing current data
  String? get currentUserName => _currentUserName;

  // Initialize profile - get user name and avatar if exists
  Future<void> initializeProfile() async {
    try {
      emit(ProfileLoading());

      // Get current user name
      final name = await _profileService.getCurrentUser();
      if (name[0] != null) {
        _currentUserName = name[0];
        date = name[1];

        // Get avatar URL if exists
        final profile = await _profileService.getUserProfile();
        if (profile != null) {
          currentAvatarUrl = profile['avatar_url'];
        }

        emit(ProfileSuccess(imageUrl: currentAvatarUrl));
      } else {
        emit(ProfileFailure('No user is signed in'));
      }
    } catch (e) {
      log('Error initializing profile: $e');
      emit(ProfileFailure('Failed to load profile: $e'));
    }
  }

  // Upload profile picture (creates new or updates existing)
  Future<void> uploadProfilePicture() async {
    try {
      emit(ProfileLoading());

      final newAvatarUrl = await _profileService.uploadProfilePicture();
      if (newAvatarUrl != null) {
        currentAvatarUrl = newAvatarUrl;
        log('Profile picture uploaded: $newAvatarUrl');
        emit(ProfileSuccess(imageUrl: currentAvatarUrl));
      } else {
        // User cancelled or no image selected
        emit(ProfileSuccess(imageUrl: currentAvatarUrl));
      }
    } catch (e) {
      log('Error uploading profile picture: $e');
      emit(ProfileFailure('Failed to upload profile picture'));
    }
  }

}