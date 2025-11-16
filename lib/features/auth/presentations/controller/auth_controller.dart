import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/common_widgets/snackbars/custom_snackbar.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/errors/supabase_exception.dart';
import 'package:mega_news/core/services/network_service.dart';
import 'package:mega_news/features/auth/domain/entity/auth_entity.dart';
import 'package:mega_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:mega_news/features/auth/presentations/pages/email_verification_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show Supabase, AuthChangeEvent;

class AuthController extends GetxController {
  final AuthRepository repo = Get.find<AuthRepository>();

  // ------------------ Form & Page ------------------
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final PageController pageController = PageController(initialPage: 0);
  final currentPage = 0.obs;

  void onPageChanged(int index) => currentPage.value = index;

  // ------------------ Text Controllers ------------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final isPasswordObscure = true.obs;
  final isConfirmPasswordObscure = true.obs;
  final isLoading = false.obs;

  // --- 🚀 FIX #3: Reactive User State - Expose user as observable for SettingsController sync
  // final user = Rxn<AuthEntity>();
  // final isGuest = false.obs; // Track guest mode

  // ================= Page Navigation =================
  Future<void> goToRegister() async {
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    await clearControllers();
  }

  Future<void> goToLogin() async {
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    await clearControllers();
  }

  Future<void> goToForgotPass() async {
    currentPage.value = 2;
    await Future.delayed(const Duration(milliseconds: 100));
    pageController.jumpToPage(2);
    await clearControllers();
  }

  Future<void> backFromForgotPass() async {
    await Future.delayed(const Duration(milliseconds: 100));
    pageController.jumpToPage(0);
    await clearControllers();
  }

  Future<void> goToNewPass() async {
    await Future.delayed(const Duration(milliseconds: 100));
    pageController.jumpToPage(3);
    await clearControllers();
  }

  Future<void> backToLogin() async {
    await Future.delayed(const Duration(milliseconds: 100));
    pageController.jumpToPage(0);
    await clearControllers();
  }

  /// ------------------ Auth Actions ------------------

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;
      // --- check net first ---
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      // ✅ FIX: Call repo.signup. The repository handles saving.
      // We still get the entity back in case we need it.
      final authEntity = await repo.signup(
        name: name,
        email: email,
        password: password,
      );

      // 🛑 FIX: Removed manual AuthEntity creation and saveAuthData call.
      // The repository implementation already did this.

      // // --- 🚀 FIX #3: Update reactive user state immediately
      // user.value = authEntity; // Now this would work
      // isGuest.value = false;

      // // --- 🚀 FIX #3: Notify SettingsController if it exists
      // try {
      //   final settingsController = Get.find<SettingsController>();
      //   settingsController.updateUserData(authEntity);
      // } catch (e) {
      //   // SettingsController might not be initialized yet, ignore
      // }

      customSnackbar(
        title: 'Account Created Successfully!',
        message: 'A verification link has been sent to your email.',
        color: AppColors.success,
      );
      Get.to(EmailVerificationPage(), transition: Transition.fadeIn);
    } on NetworkException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection and try again.',
        color: AppColors.error,
      );
    } on UserAlreadyExistsException {
      customSnackbar(
        title: 'Email Already Registered',
        message: 'This email is already in use. Please log in instead.',
        color: AppColors.warning,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: 'Signup Error',
        message: e.message,
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong. Please try again later.',
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      // ✅ FIX: Use repo.login instead of undefined 'auth.signIn'
      final authEntity = await repo.login(email: email, password: password);

      // 🛑 FIX: Removed manual AuthEntity creation and saveAuthData call.
      // The repository implementation already did this.

      // --- 🚀 FIX #3: Update reactive user state immediately
      // user.value = authEntity; // Now this would work
      // isGuest.value = false;

      // // --- 🚀 FIX #3: Notify SettingsController if it exists
      // try {
      //   final settingsController = Get.find<SettingsController>();
      //   settingsController.updateUserData(authEntity);
      // } catch (e) {
      //   // SettingsController might not be initialized yet, ignore
      // }

      // // Sync favorites after login
      // try {
      //   final favoritesController = Get.find<FavoritesController>();
      //   await favoritesController.onUserLogin();
      // } catch (e) {
      //   // Favorites controller might not be initialized yet, ignore
      //   print('Could not sync favorites on login: $e');
      // }

      customSnackbar(
        title: 'Welcome Back!',
        message: 'You\'ve signed in successfully.',
        color: AppColors.success,
      );
    } on NetworkException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection and try again.',
        color: AppColors.error,
      );
    } on MissingDataException {
      customSnackbar(
        title: 'Invalid Credentials',
        message: 'Incorrect email or password. Please try again.',
        color: AppColors.warning,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: 'Sign-in Error',
        message: e.message,
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong. Please try again later.',
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    try {
      isLoading.value = true;
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      // ✅ FIX: Use repo.googleSignIn instead of undefined 'auth.googleSignIN'
      final authEntity = await repo.googleSignIn();

      // 🛑 FIX: Removed manual AuthEntity creation and saveAuthData call.
      // The repository implementation already did this.

      // --- 🚀 FIX #3: Update reactive user state immediately
      // user.value = authEntity; // Now this would work
      // isGuest.value = false;

      // // --- 🚀 FIX #3: Notify SettingsController if it exists
      // try {
      //   final settingsController = Get.find<SettingsController>();
      //   settingsController.updateUserData(authEntity);
      // } catch (e) {
      //   // SettingsController might not be initialized yet, ignore
      // }

      // // Sync favorites after login
      // try {
      //   final favoritesController = Get.find<FavoritesController>();
      //   await favoritesController.onUserLogin();
      // } catch (e) {
      //   // Favorites controller might not be initialized yet, ignore
      //   print('Could not sync favorites on login: $e');
      // }

      customSnackbar(
        title: 'Welcome!',
        message: 'Signed in successfully with Google.',
        color: AppColors.success,
      );
    } on NetworkException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection and try again.',
        color: AppColors.error,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: 'Sign-in Error',
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong. Please try again later.',
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      // --- check net first ---
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      // ✅ FIX: Use repo.logout.
      await repo.logout();
      // 🛑 FIX: Removed localAuth.clearAuthData().
      // The repo.logout() implementation should handle this.

      // // --- 🚀 FIX #3: Clear reactive user state
      // user.value = null;
      // isGuest.value = false;

      // // --- 🚀 FIX #3: Notify SettingsController if it exists
      // try {
      //   final settingsController = Get.find<SettingsController>();
      //   settingsController.clearUserData();
      // } catch (e) {
      //   // SettingsController might not be initialized yet, ignore
      // }

      // // Clear user-specific favorites on logout
      // try {
      //   final favoritesController = Get.find<FavoritesController>();
      //   favoritesController.onUserLogout();
      // } catch (e) {
      //   // Favorites controller might not be initialized yet, ignore
      //   print('Could not clear favorites on logout: $e');
      // }

      customSnackbar(
        title: 'Logged Out',
        message: 'You have been logged out successfully.',
        color: AppColors.success,
      );
      goToLogin();
    } on NetworkException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection and try again.',
        color: AppColors.error,
      );
    } on UserNotFoundException catch (e) {
      customSnackbar(
        title: 'User Not Found',
        message: e.message,
        color: AppColors.error,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: 'Logout Error',
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong. Please try again later.',
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }

      // ✅ FIX: Use repo.getCurrentUser()
      final currentUser = await repo.getCurrentUser();
      if (currentUser == null) {
        throw const UserNotFoundException('No user is currently logged in.');
      }

      // ✅ FIX: Use repo.deleteAccount()
      await repo.deleteAccount(currentUser.id);
      // 🛑 FIX: Removed localAuth.clearAuthData().
      // The repo.deleteAccount() implementation should handle this.

      // // --- 🚀 FIX #3: Clear reactive user state
      // user.value = null;
      // isGuest.value = false;

      // // --- 🚀 FIX #3: Notify SettingsController if it exists
      // try {
      //   final settingsController = Get.find<SettingsController>();
      //   settingsController.clearUserData();
      // } catch (e) {
      //   // SettingsController might not be initialized yet, ignore
      // }

      // // Clear user-specific favorites on account deletion
      // try {
      //   final favoritesController = Get.find<FavoritesController>();
      //   favoritesController.onUserLogout();
      // } catch (e) {
      //   // Favorites controller might not be initialized yet, ignore
      //   print('Could not clear favorites on account deletion: $e');
      // }

      customSnackbar(
        title: 'Account Deleted',
        message: 'Your account has been permanently removed.',
        color: AppColors.success,
      );
      goToLogin();
    } on NetworkException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection and try again.',
        color: AppColors.error,
      );
    } on UserNotFoundException catch (e) {
      customSnackbar(
        title: 'User Not Found',
        message: e.message,
        color: AppColors.error,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: 'Deletion Failed',
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong. Please try again later.',
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      isLoading.value = true;
      // --- check net first ---
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      // ✅ FIX: Use repo.updatePassword()
      await repo.updatePassword(newPassword);

      customSnackbar(
        title: 'Password Updated',
        message: 'Your password has been changed successfully.',
        color: AppColors.success,
      );

      backToLogin();
    } on NetworkException {
      customSnackbar(
        title: 'No Connection',
        message: 'Please check your internet connection and try again.',
        color: AppColors.error,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: 'Update Error',
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong. Please try again later.',
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    try {
      // This check is fine here before loading
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }

      isLoading.value = true;

      // ✅ FIX: Use repo.resetPassword()
      await repo.resetPassword(email);

      customSnackbar(
        title: 'Email Sent',
        message: 'A password reset link has been sent to your email.',
        color: AppColors.success,
      );
      emailController.clear();
    } on UserNotFoundException {
      customSnackbar(
        title: 'User Not Found',
        message: 'No account found with this email.',
        color: AppColors.error,
      );
    } on NetworkException {
      customSnackbar(
        title: 'No Internet',
        message: 'Please check your connection and try again.',
        color: AppColors.warning,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: 'Error',
        message: e.message,
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: 'Unexpected Error',
        message: 'Something went wrong. Please try again later.',
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();

    // --- 🚀 FIX #3: Load initial user data from local storage
    // _loadUserData();

    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final sessionUser = data.session?.user;

      if (event == AuthChangeEvent.passwordRecovery) {
        goToNewPass();
        return;
      }

      if (event == AuthChangeEvent.signedIn && sessionUser != null) {
        if (sessionUser.emailConfirmedAt != null) {
          GetStorage().write('loginBefore', true);

          // --- 🚀 FIX #3: Update user state from session
          // Note: sessionUser.createdAt is already a String in ISO8601 format
          final authEntity = AuthEntity(
            id: sessionUser.id,
            name:
                sessionUser.userMetadata?['name'] ??
                sessionUser.email?.split('@')[0] ??
                'User',
            email: sessionUser.email ?? '',
            createdAt: sessionUser.createdAt,
          );
          // user.value = authEntity;
          // isGuest.value = false;

          // --- 🚀 FIX #3: Notify SettingsController if it exists
          // try {
          //   final settingsController = Get.find<SettingsController>();
          //   settingsController.updateUserData(authEntity);
          // } catch (e) {
          //   // SettingsController might not be initialized yet, ignore
          // }

          // // Sync favorites after successful sign in
          // try {
          //   final favoritesController = Get.find<FavoritesController>();
          //   favoritesController.onUserLogin().catchError((e) {
          //     print('Could not sync favorites on auth state change: $e');
          //   });
          // } catch (e) {
          //   // Favorites controller might not be initialized yet, ignore
          //   print('Could not sync favorites on auth state change: $e');
          // }
          // Get.offAllNamed(AppPages.loyoutPage);
        }
      } else if (event == AuthChangeEvent.signedOut) {
        // --- 🚀 FIX #3: Clear user state on sign out
        // user.value = null;
        // isGuest.value = false;
        try {
          // final settingsController = Get.find<SettingsController>();
          // settingsController.clearUserData();
        } catch (e) {
          // SettingsController might not be initialized yet, ignore
        }
      }
    });
  }

  // --- 🚀 FIX #3: Load user data from local storage
  // void _loadUserData() async { // Needs to be async
  //   // ✅ FIX: Use repo.getCurrentUser()
  //   final authData = await repo.getCurrentUser();
  //   if (authData != null) {
  //     user.value = authData;
  //     isGuest.value = false;
  //   } else {
  //     // Check if user is in guest mode
  //     final storage = GetStorage();
  //     final loginBefore = storage.read('loginBefore') ?? false;
  //     isGuest.value = loginBefore && user.value == null;
  //   }
  // }

  // ------------------ Helpers ------------------
  Future<void> clearControllers() async {
    nameController.clear();
    emailController.clear();
    passController.clear();
    confirmPassController.clear();
    isPasswordObscure.value = true;
    isConfirmPasswordObscure.value = true;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
