import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mega_news/core/custom/custom_snackbar.dart';
import 'package:mega_news/core/constants/app_colors.dart';
import 'package:mega_news/core/errors/supabase_exception.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
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

  // قمنا بتغيير الاسم هنا ليتطابق مع AuthPage
  final currentPageIndex = 0.obs;

  void onPageChanged(int index) => currentPageIndex.value = index;

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
    // تحديث المؤشر يدوياً لسرعة الاستجابة في UI
    currentPageIndex.value = 1;
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    await clearControllers();
  }

  Future<void> goToLogin() async {
    currentPageIndex.value = 0;
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    await clearControllers();
  }

  Future<void> goToForgotPass() async {
    currentPageIndex.value = 2;
    await Future.delayed(const Duration(milliseconds: 100));
    pageController.jumpToPage(2);
    await clearControllers();
  }

  Future<void> backFromForgotPass() async {
    currentPageIndex.value = 0;
    await Future.delayed(const Duration(milliseconds: 100));
    pageController.jumpToPage(0);
    await clearControllers();
  }

  Future<void> goToNewPass() async {
    currentPageIndex.value = 3;
    await Future.delayed(const Duration(milliseconds: 100));
    pageController.jumpToPage(3);
    await clearControllers();
  }

  Future<void> backToLogin() async {
    currentPageIndex.value = 0;
    await Future.delayed(const Duration(milliseconds: 100));
    pageController.jumpToPage(0);
    await clearControllers();
  }

  /// ------------------ Auth Actions ------------------
  final Rxn<AuthEntity> user = Rxn<AuthEntity>();

  Future<void> signUp(String name, String email, String password) async {
    final s = Get.context!.s;
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

      user.value = authEntity;

      // Save user to storage
      _saveUserToStorage(authEntity);

      customSnackbar(
        title: s.auth_signup_success_title,
        message: s.auth_signup_success_msg,
        color: AppColors.success,
      );
      Get.to(
        () => const EmailVerificationPage(),
        transition: Transition.fadeIn,
        arguments: email,
      );
    } on NetworkException {
      customSnackbar(
        title: s.error_no_connection_title,
        message: s.error_no_connection_msg,
        color: AppColors.error,
      );
    } on UserAlreadyExistsException {
      customSnackbar(
        title: s.auth_email_exists_title,
        message: s.auth_email_exists_msg,
        color: AppColors.warning,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: s.auth_signup_error_title,
        message: e.message,
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: s.error_unexpected_title,
        message: s.error_unexpected_msg,
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    final s = Get.context!.s;
    try {
      isLoading.value = true;
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      final authEntity = await repo.login(email: email, password: password);
      user.value = authEntity;

      // Save user data to storage
      _saveUserToStorage(authEntity);
      await GetStorage().write('loginBefore', true);

      customSnackbar(
        title: s.auth_login_success_title,
        message: s.auth_login_success_msg,
        color: AppColors.success,
      );
    } on NetworkException {
      customSnackbar(
        title: s.error_no_connection_title,
        message: s.error_no_connection_msg,
        color: AppColors.error,
      );
    } on MissingDataException {
      customSnackbar(
        title: s.auth_invalid_creds_title,
        message: s.auth_invalid_creds_msg,
        color: AppColors.warning,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: s.auth_login_error_title,
        message: e.message,
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: s.error_unexpected_title,
        message: s.error_unexpected_msg,
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    final s = Get.context!.s;
    try {
      isLoading.value = true;
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      final authEntity = await repo.googleSignIn();
      user.value = authEntity;

      // Save user to storage
      _saveUserToStorage(authEntity);
      await GetStorage().write('loginBefore', true);

      customSnackbar(
        title: s.auth_google_welcome_title,
        message: s.auth_google_success_msg,
        color: AppColors.success,
      );
    } on NetworkException {
      customSnackbar(
        title: s.error_no_connection_title,
        message: s.error_no_connection_msg,
        color: AppColors.error,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: s.auth_login_error_title,
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: s.error_unexpected_title,
        message: s.error_unexpected_msg,
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final s = Get.context!.s;
    try {
      isLoading.value = true;
      // --- check net first ---
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      await repo.logout();
      customSnackbar(
        title: s.auth_logout_title,
        message: s.auth_logout_msg,
        color: AppColors.success,
      );
      goToLogin();
    } on NetworkException {
      customSnackbar(
        title: s.error_no_connection_title,
        message: s.error_no_connection_msg,
        color: AppColors.error,
      );
    } on UserNotFoundException catch (e) {
      customSnackbar(
        title: s.error_user_not_found_title,
        message: e.message,
        color: AppColors.error,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: s.auth_logout_error_title,
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: s.error_unexpected_title,
        message: s.error_unexpected_msg,
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    final s = Get.context!.s;
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
        title: s.auth_account_deleted_title,
        message: s.auth_account_deleted_msg,
        color: AppColors.success,
      );
      goToLogin();
    } on NetworkException {
      customSnackbar(
        title: s.error_no_connection_title,
        message: s.error_no_connection_msg,
        color: AppColors.error,
      );
    } on UserNotFoundException catch (e) {
      customSnackbar(
        title: s.error_user_not_found_title,
        message: e.message,
        color: AppColors.error,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: s.auth_deletion_failed_title,
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: s.error_unexpected_title,
        message: s.error_unexpected_msg,
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final s = Get.context!.s;
    try {
      isLoading.value = true;
      // --- check net first ---
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }
      // ------------------------

      await repo.updatePassword(newPassword);

      customSnackbar(
        title: s.auth_pass_updated_title,
        message: s.auth_pass_updated_msg,
        color: AppColors.success,
      );

      backToLogin();
    } on NetworkException {
      customSnackbar(
        title: s.error_no_connection_title,
        message: s.error_no_connection_msg,
        color: AppColors.error,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: s.auth_update_error_title,
        message: e.message,
        color: AppColors.warning,
      );
    } catch (e) {
      customSnackbar(
        title: s.error_unexpected_title,
        message: s.error_unexpected_msg,
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    final s = Get.context!.s;
    final email = emailController.text.trim();

    try {
      if (!await NetworkService.isConnected) {
        throw const NetworkException('No internet connection.');
      }

      isLoading.value = true;

      await repo.resetPassword(email);

      customSnackbar(
        title: s.auth_reset_email_sent_title,
        message: s.auth_reset_email_sent_msg,
        color: AppColors.success,
      );
      emailController.clear();
    } on UserNotFoundException {
      customSnackbar(
        title: s.error_user_not_found_title,
        message: s.error_user_not_found_msg,
        color: AppColors.error,
      );
    } on NetworkException {
      customSnackbar(
        title: s.error_no_connection_title,
        message: s.error_no_connection_msg,
        color: AppColors.warning,
      );
    } on AuthException catch (e) {
      customSnackbar(
        title: s.error_unexpected_title,
        message: e.message,
        color: AppColors.error,
      );
    } catch (e) {
      customSnackbar(
        title: s.error_unexpected_title,
        message: s.error_unexpected_msg,
        color: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loginGuest() {
    final s = Get.context!.s;
    user.value = AuthEntity(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Guest',
      email: 'guest@Mega.news',
      createdAt: DateTime.now().toIso8601String(),
    );

    // Save guest user to storage
    _saveUserToStorage(user.value!);
    GetStorage().write('loginBefore', true);

    customSnackbar(
      title: s.auth_guest_welcome_title,
      message: s.auth_guest_welcome_msg,
      color: AppColors.success,
    );

    Get.offAllNamed(AppPages.layoutPage);
  }

  void _saveUserToStorage(AuthEntity authEntity) {
    // try {
    final userMap = {
      'id': authEntity.id,
      'name': authEntity.name,
      'email': authEntity.email,
      'createdAt': authEntity.createdAt,
    };
    GetStorage().write('auth_data', userMap);
  }

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();

    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final sessionUser = data.session?.user;

      WidgetsBinding.instance.addPostFrameCallback((_) {
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
            _saveUserToStorage(authEntity);
          }

          Get.offAllNamed(AppPages.layoutPage);
        } else if (event == AuthChangeEvent.signedOut) {
          user.value = null;
          GetStorage().remove('auth_data');
        }
      });
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
