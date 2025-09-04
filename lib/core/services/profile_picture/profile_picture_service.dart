import 'dart:io';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  // Get current user name
  Future<List<String?>> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    return [user?.userMetadata?['name'] ?? user?.email, user?.createdAt];
  }

  // Get user profile from database
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('profiles')
          .select('avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      return response;
    } catch (e) {
      log('Error getting user profile: $e');
      return null;
    }
  }

  // Upload profile picture
  Future<String?> uploadProfilePicture() async {
    try {
      // Check authentication
      final user = _supabase.auth.currentUser;
      if (user == null) {
        log('User not authenticated');
        return null;
      }

      log('=== STARTING UPLOAD ===');
      log('User ID: ${user.id}');

      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image == null) {
        log('No image selected');
        return null;
      }

      final File imageFile = File(image.path);
      final String fileExt = extension(image.path);
      // Use consistent filename for easy replacement
      final String fileName = '${user.id}/profile$fileExt';

      log('Uploading file: $fileName');
      log('File exists: ${await imageFile.exists()}');
      log('File size: ${await imageFile.length()} bytes');

      // Upload to Supabase Storage with upsert
      await _supabase.storage.from('avatars').upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(
          upsert: true, // Replace existing file
          cacheControl: '3600',
        ),
      );

      log('✅ Storage upload successful');

      // Get public URL
      final String publicUrl = _supabase.storage
          .from('avatars')
          .getPublicUrl(fileName);

      log('Public URL: $publicUrl');

      // Update user profile in database
      await _updateUserProfile(publicUrl);

      log('✅ Profile updated successfully');
      return publicUrl;

    } catch (e) {
      log('❌ Upload failed: $e');
      if (e is StorageException) {
        log('StorageException details:');
        log('  Message: ${e.message}');
        log('  StatusCode: ${e.statusCode}');
        log('  Error: ${e.error}');
      }
      rethrow;
    }
  }

  // Private method to update user profile in database
  Future<void> _updateUserProfile(String avatarUrl) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _supabase.from('profiles').upsert({
        'id': user.id,
        'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      log('Database profile updated');
    } catch (e) {
      log('Error updating profile: $e');
      rethrow;
    }
  }
}