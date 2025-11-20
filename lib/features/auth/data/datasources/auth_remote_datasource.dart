import 'dart:io';

import 'package:mega_news/core/errors/supabase_exception.dart';
import 'package:mega_news/core/services/network_service.dart';
import 'package:mega_news/features/auth/data/model/auth_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<AuthModel> signIn({required String email, required String password});
  Future<void> resetPassword(String email);
  Future<void> updatePassword(String newPassword);
  Future<AuthModel> googleSignIN();
  Future<void> logout();
  Future<void> deleteAccount(String userId);
  bool get isLoggedIn;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final supabase = Supabase.instance.client;

  // ================= Sign Up =================
  @override
  Future<AuthModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await NetworkService.isConnected) {
      throw const NetworkException('No internet connection.');
    }
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
        emailRedirectTo: 'io.supabase.flutter://login-callback/',
      );

      if (res.user != null) {
        final identities = res.user!.identities;
        if (identities == null || identities.isEmpty) {
          throw const UserAlreadyExistsException('User already registered');
        }
        if (res.user!.emailConfirmedAt != null) {
          throw const UserAlreadyExistsException('User already registered');
        }
        // ----------------------------------------------------

        final data = AuthModel(
          id: res.user!.id,
          name: name,
          email: email,
          createdAtDate: DateTime.now(),
        );

        await supabase.from('profiles').insert(data.toMap());
        return data;
      } else {
        throw const AuthException(
          'Signup failed - no user created',
          'signup_failed',
        );
      }
    } on UserAlreadyExistsException {
      rethrow;
    } on AuthApiException catch (e) {
      if (e.code == 'user_already_exists' ||
          e.code == 'email_exists' ||
          // ignore: unrelated_type_equality_checks
          e.statusCode == 409 ||
          // ignore: unrelated_type_equality_checks
          e.statusCode == 422) {
        throw const UserAlreadyExistsException('User already registered');
      }
      throw AuthException(e.message, e.code);
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } catch (e) {
      throw AuthException('Unexpected error: ${e.toString()}');
    }
  }

  // ================= Sign In =================
  @override
  Future<AuthModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final profileResponse = await supabase
          .from('profiles')
          .select('*')
          .eq('id', res.user!.id)
          .maybeSingle();

      if (profileResponse == null) {
        throw const MissingDataException('Profile not found.');
      }

      return AuthModel.fromMap(profileResponse);
    } on AuthApiException catch (e) {
      if (e.code == 'invalid_credentials' ||
          // ignore: unrelated_type_equality_checks
          e.statusCode == 400 ||
          e.message.toLowerCase().contains('invalid login credentials')) {
        throw const MissingDataException('Invalid login credentials');
      }
      throw AuthException(e.message, e.code);
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } catch (e) {
      throw AuthException('Unexpected error: ${e.toString()}');
    }
  }

  // ================= Reset Password =================
  @override
  Future<void> resetPassword(String email) async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-password/',
      );
    } on AuthApiException catch (e) {
      if (e.code == 'invalid_credentials' ||
          // ignore: unrelated_type_equality_checks
          e.statusCode == 400 ||
          e.message.toLowerCase().contains('email not found')) {
        throw const UserNotFoundException('No account found for this email.');
      }
      throw AuthException(e.message, e.code);
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } catch (_) {
      throw const AuthException('Something went wrong. Please try again.');
    }
  }

  // ================= Update Password =================
  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthApiException catch (e) {
      throw AuthException(e.message, e.code);
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } catch (e) {
      throw const AuthException('Unexpected error while updating password.');
    }
  }

  // google signIN
  @override
  Future<AuthModel> googleSignIN() async {
    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(
        clientId: dotenv.env['CLIENT_ID']!,
        serverClientId: dotenv.env['SERVER_CLIENT_ID']!,
      );

      final googleUser = await googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthException('Google Sign-In failed: Missing ID Token.');
      }

      // login in supabase auth tables
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = response.user;
      if (user == null || response.session == null) {
        throw const AuthException('Google sign-in failed: No session created.');
      }

      //check its signing after this time to get him data
      final profileResponse = await supabase
          .from('profiles')
          .select('*')
          .eq('id', user.id)
          .maybeSingle();

      late AuthModel userProfile;

      if (profileResponse == null) {
        //create new table if not exits
        userProfile = AuthModel(
          id: user.id,
          name: user.userMetadata?['name'] ?? user.email ?? '',
          email: user.email ?? '',
          createdAtDate: DateTime.now(),
        );

        await supabase.from('profiles').insert(userProfile.toMap());
      } else {
        userProfile = AuthModel.fromMap(profileResponse);
      }

      return userProfile;
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } catch (e) {
      throw AuthException('Unexpected error during Google Sign-In: $e');
    }
  }

  // ================= Sign Out =================
  @override
  Future<void> logout() async {
    if (!await NetworkService.isConnected) {
      throw const NetworkException('No internet connection.');
    }
    // ----------------------------------------
    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthException('Logout failed: ${e.message}');
    } catch (e) {
      throw UserNotFoundException('Unexpected error during logout: $e');
    }
  }

  final supabaseAdmin = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_SERVICEROLE']!,
  );

  @override
  Future<void> deleteAccount(String userId) async {
    if (!await NetworkService.isConnected) {
      throw const NetworkException('No internet connection.');
    }

    try {
      // Delete profile data
      await supabase.from('profiles').delete().eq('id', userId);
      await supabaseAdmin.auth.admin.deleteUser(userId);

      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } catch (e) {
      throw UserNotFoundException('Failed to delete account: $e');
    }
  }

  // ================= Check Logged In =================
  @override
  bool get isLoggedIn => supabase.auth.currentUser != null;
}
