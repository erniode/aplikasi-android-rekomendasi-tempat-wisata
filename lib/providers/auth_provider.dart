import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _auth.currentUser != null;

  // -------------------------
// LOGIN (Firebase) - Optimized
// -------------------------
  Future<bool> login(String username, String password) async {
    try {
      // Firebase memakai email untuk username
      final result = await _auth.signInWithEmailAndPassword(
        email: username.trim(),
        password: password.trim(),
      );

      // Create basic user model immediately for fast UI update
      _user = UserModel(
        uid: result.user!.uid,
        username: result.user!.email ?? username,
        role: 'user',
      );
      notifyListeners();

      // Fetch additional profile data asynchronously (non-blocking)
      _fetchProfileData(result.user!.uid);

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("LOGIN ERROR: ${e.message}");
      return false;
    }
  }

  // Helper method to fetch profile data asynchronously
  void _fetchProfileData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      final userData = userDoc.data() ?? {};

      // Update with full profile data
      _user = UserModel.fromMap(userData, uid);
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to fetch profile data: $e");
      // Keep basic user data if profile fetch fails
    }
  }

  // -------------------------
// REGISTER (Firebase) - Optimized
// -------------------------
  Future<String?> register(String username, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: username.trim(),
        password: password.trim(),
      );

      // Create basic user model immediately for fast UI update
      final userModel = UserModel(
        uid: result.user!.uid,
        username: result.user!.email ?? username,
        role: 'user',
      );

      _user = userModel;
      notifyListeners();

      // Save user data to Firestore asynchronously (non-blocking)
      _saveUserDataToFirestore(userModel);

      return null; // Success, no error message
    } on FirebaseAuthException catch (e) {
      debugPrint("REGISTER ERROR: ${e.code} - ${e.message}");

      // Return user-friendly error messages
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email sudah terdaftar. Silakan gunakan email lain.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'weak-password':
          return 'Password terlalu lemah. Minimal 6 karakter.';
        case 'network-request-failed':
          return 'Koneksi internet bermasalah. Periksa koneksi Anda.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Coba lagi nanti.';
        default:
          return 'Pendaftaran gagal: ${e.message}';
      }
    } catch (e) {
      debugPrint("REGISTER GENERAL ERROR: $e");
      return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  // Helper method to save user data to Firestore asynchronously
  void _saveUserDataToFirestore(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());
      debugPrint("User data saved to Firestore successfully");
    } catch (e) {
      debugPrint("Failed to save user data to Firestore: $e");
      // User account is created but profile data save failed
      // This is not critical for registration success
    }
  }

  // -------------------------
  // LOGOUT (Firebase)
  // -------------------------
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  // -------------------------
  // DELETE USER (Firebase)
  // -------------------------
  Future<String?> deleteUser(String password) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return 'User tidak ditemukan';

      // Re-authenticate user before deletion
      final credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );
      await currentUser.reauthenticateWithCredential(credential);

      // Delete user data from Firestore
      await _firestore.collection('users').doc(currentUser.uid).delete();

      // Delete user account from Firebase Auth
      await currentUser.delete();

      // Clear local user data
      _user = null;
      notifyListeners();

      return null; // Success
    } on FirebaseAuthException catch (e) {
      debugPrint("DELETE USER ERROR: ${e.code} - ${e.message}");

      // Return user-friendly error messages
      switch (e.code) {
        case 'wrong-password':
          return 'Password salah. Silakan coba lagi.';
        case 'user-mismatch':
          return 'Kredensial tidak valid.';
        case 'user-not-found':
          return 'User tidak ditemukan.';
        case 'invalid-credential':
          return 'Kredensial tidak valid.';
        case 'network-request-failed':
          return 'Koneksi internet bermasalah. Periksa koneksi Anda.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Coba lagi nanti.';
        default:
          return 'Gagal menghapus akun: ${e.message}';
      }
    } catch (e) {
      debugPrint("DELETE USER GENERAL ERROR: $e");
      return 'Terjadi kesalahan saat menghapus akun.';
    }
  }

  // -------------------------
// AUTO LOGIN - Optimized
// -------------------------
  Future<void> tryAutoLogin() async {
    final current = _auth.currentUser;

    if (current != null) {
      // Create basic user model first for immediate UI update
      _user = UserModel(
        uid: current.uid,
        username: current.email ?? '',
        role: 'user',
      );
      notifyListeners();

      // Fetch additional profile data asynchronously (non-blocking)
      _fetchProfileData(current.uid);
    }
  }

  // -------------------------
  // UPDATE PROFILE
  // -------------------------
  Future<bool> updateProfile(String name, int age, String gender) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      await _firestore.collection('users').doc(currentUser.uid).update({
        'name': name,
        'age': age,
        'gender': gender,
      });

      // Update local user model
      if (_user != null) {
        _user = _user!.copyWith(name: name, age: age, gender: gender);
        notifyListeners();
      }

      return true;
    } catch (e) {
      debugPrint("UPDATE PROFILE ERROR: $e");
      return false;
    }
  }

  // -------------------------
  // PICK PROFILE IMAGE
  // -------------------------
  Future<XFile?> pickProfileImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      return pickedFile;
    } catch (e) {
      debugPrint("PICK IMAGE ERROR: $e");
      return null;
    }
  }

  // -------------------------
  // UPLOAD PROFILE IMAGE TO FIREBASE STORAGE
  // -------------------------
  Future<String?> uploadProfileImage(XFile imageFile) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      // Create unique filename
      final fileName =
          'profile_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref().child('profile_images/$fileName');

      // Upload file
      final uploadTask = storageRef.putFile(
        File(imageFile.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Wait for upload to complete
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update user profile in Firestore
      await _firestore.collection('users').doc(currentUser.uid).update({
        'profilePictureUrl': downloadUrl,
      });

      // Update local user model
      if (_user != null) {
        _user = _user!.copyWith(profilePictureUrl: downloadUrl);
        notifyListeners();
      }

      return downloadUrl;
    } catch (e) {
      debugPrint("UPLOAD IMAGE ERROR: $e");
      return null;
    }
  }

  // -------------------------
  // UPDATE PROFILE WITH IMAGE
  // -------------------------
  Future<bool> updateProfileWithImage(
      String name, int age, String gender, XFile? imageFile) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      String? profilePictureUrl;

      // Upload image if provided
      if (imageFile != null) {
        profilePictureUrl = await uploadProfileImage(imageFile);
        if (profilePictureUrl == null) {
          debugPrint("Failed to upload profile image");
          // Continue with profile update even if image upload fails
        }
      }

      // Update profile data
      final updateData = {
        'name': name,
        'age': age,
        'gender': gender,
      };

      if (profilePictureUrl != null) {
        updateData['profilePictureUrl'] = profilePictureUrl;
      }

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update(updateData);

      // Update local user model
      if (_user != null) {
        _user = _user!.copyWith(
          name: name,
          age: age,
          gender: gender,
          profilePictureUrl: profilePictureUrl,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      debugPrint("UPDATE PROFILE WITH IMAGE ERROR: $e");
      return false;
    }
  }
}
