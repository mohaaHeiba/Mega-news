import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/custom/snackbars/custom_snackbar.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/errors/supabase_exception.dart';
import 'package:mega_news/core/routes/app_pages.dart';
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

  final Rxn<AuthEntity> user = Rxn<AuthEntity>();

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      final authEntity = await repo.signup(
        name: name,
        email: email,
        password: password,
      );

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

      final authEntity = await repo.login(email: email, password: password);

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

      final authEntity = await repo.googleSignIn();
      user.value = authEntity;
      print(user.value!.name);
      await GetStorage().write('loginBefore', true);

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

      await repo.logout();
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

      final currentUser = await repo.getCurrentUser();
      if (currentUser == null) {
        throw const UserNotFoundException('No user is currently logged in.');
      }

      await repo.deleteAccount(currentUser.id);

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

          final authEntity = AuthEntity(
            id: sessionUser.id,
            name:
                sessionUser.userMetadata?['name'] ??
                sessionUser.email?.split('@')[0] ??
                'User',
            email: sessionUser.email ?? '',
            createdAt: sessionUser.createdAt,
          );
          user.value = authEntity;
        }

        Get.toNamed(AppPages.layoutPage);
      } else if (event == AuthChangeEvent.signedOut) {
        try {} catch (e) {
          // SettingsController might not be initialized yet, ignore
        }
      }
    });
  }

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
