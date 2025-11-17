// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `News from Everywhere`
  String get welcomeTitle1 {
    return Intl.message(
      'News from Everywhere',
      name: 'welcomeTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Follow news from multiple reliable sources in one app`
  String get welcomeSubtitle1 {
    return Intl.message(
      'Follow news from multiple reliable sources in one app',
      name: 'welcomeSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `Smart Search & Instant Summaries`
  String get welcomeTitle2 {
    return Intl.message(
      'Smart Search & Instant Summaries',
      name: 'welcomeTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Search any topic and get a comprehensive summary of related news`
  String get welcomeSubtitle2 {
    return Intl.message(
      'Search any topic and get a comprehensive summary of related news',
      name: 'welcomeSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Save What Matters`
  String get welcomeTitle3 {
    return Intl.message(
      'Save What Matters',
      name: 'welcomeTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Add important news to favorites and read them anytime`
  String get welcomeSubtitle3 {
    return Intl.message(
      'Add important news to favorites and read them anytime',
      name: 'welcomeSubtitle3',
      desc: '',
      args: [],
    );
  }

  /// `Real-time Notifications`
  String get welcomeTitle4 {
    return Intl.message(
      'Real-time Notifications',
      name: 'welcomeTitle4',
      desc: '',
      args: [],
    );
  }

  /// `Be the first to know breaking news from all sources`
  String get welcomeSubtitle4 {
    return Intl.message(
      'Be the first to know breaking news from all sources',
      name: 'welcomeSubtitle4',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `______________________________________`
  String get auth {
    return Intl.message(
      '______________________________________',
      name: 'auth',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get enterName {
    return Intl.message(
      'Please enter your name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters`
  String get nameMinChars {
    return Intl.message(
      'Name must be at least 3 characters',
      name: 'nameMinChars',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address`
  String get enterEmail {
    return Intl.message(
      'Please enter your email address',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get enterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordMinChars {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordMinChars',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one uppercase letter and one number`
  String get passwordUpperNumber {
    return Intl.message(
      'Password must contain at least one uppercase letter and one number',
      name: 'passwordUpperNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirmPassword {
    return Intl.message(
      'Please confirm your password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Create New Password`
  String get create {
    return Intl.message(
      'Create New Password',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Set a strong new password to secure your account.`
  String get set_strong_password {
    return Intl.message(
      'Set a strong new password to secure your account.',
      name: 'set_strong_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirm_new_password {
    return Intl.message(
      'Confirm New Password',
      name: 'confirm_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get update_password {
    return Intl.message(
      'Update Password',
      name: 'update_password',
      desc: '',
      args: [],
    );
  }

  /// `Remembered your password?`
  String get remembered_password {
    return Intl.message(
      'Remembered your password?',
      name: 'remembered_password',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcome_back {
    return Intl.message(
      'Welcome Back!',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Log in to your account to continue`
  String get login_to_continue {
    return Intl.message(
      'Log in to your account to continue',
      name: 'login_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email {
    return Intl.message('Email Address', name: 'email', desc: '', args: []);
  }

  /// `Enter your email`
  String get enter_email {
    return Intl.message(
      'Enter your email',
      name: 'enter_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter your password`
  String get enter_password {
    return Intl.message(
      'Enter your password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get log_in {
    return Intl.message('Log In', name: 'log_in', desc: '', args: []);
  }

  /// `or continue with`
  String get or_continue_with {
    return Intl.message(
      'or continue with',
      name: 'or_continue_with',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get sign_in_with_google {
    return Intl.message(
      'Sign in with Google',
      name: 'sign_in_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account? `
  String get dont_have_account {
    return Intl.message(
      'Don’t have an account? ',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message('Sign Up', name: 'sign_up', desc: '', args: []);
  }

  /// `Create Your Account`
  String get registerTitle {
    return Intl.message(
      'Create Your Account',
      name: 'registerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Join us and start exploring all the amazing features we offer!`
  String get registerSubtitle {
    return Intl.message(
      'Join us and start exploring all the amazing features we offer!',
      name: 'registerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name`
  String get hintFullName {
    return Intl.message(
      'Enter your full name',
      name: 'hintFullName',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get labelFullName {
    return Intl.message('Full Name', name: 'labelFullName', desc: '', args: []);
  }

  /// `Enter your email address`
  String get hintEmail {
    return Intl.message(
      'Enter your email address',
      name: 'hintEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get labelEmail {
    return Intl.message(
      'Email Address',
      name: 'labelEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get hintPassword {
    return Intl.message(
      'Enter your password',
      name: 'hintPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get labelPassword {
    return Intl.message('Password', name: 'labelPassword', desc: '', args: []);
  }

  /// `Re-enter your password`
  String get hintConfirmPassword {
    return Intl.message(
      'Re-enter your password',
      name: 'hintConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get labelConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'labelConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get buttonSignUp {
    return Intl.message('Sign Up', name: 'buttonSignUp', desc: '', args: []);
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get buttonLogin {
    return Intl.message('Log In', name: 'buttonLogin', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email below and we’ll send you a link to reset your password.`
  String get forgotPasswordSubtitle {
    return Intl.message(
      'Enter your email below and we’ll send you a link to reset your password.',
      name: 'forgotPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get buttonSendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'buttonSendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Remember your password?`
  String get rememberPassword {
    return Intl.message(
      'Remember your password?',
      name: 'rememberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your email to continue...`
  String get emailVerificationInstruction {
    return Intl.message(
      'Please verify your email to continue...',
      name: 'emailVerificationInstruction',
      desc: '',
      args: [],
    );
  }

  /// `We've sent a verification link to `
  String get emailVerificationMessage {
    return Intl.message(
      'We\'ve sent a verification link to ',
      name: 'emailVerificationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Briefing`
  String get briefing {
    return Intl.message('Briefing', name: 'briefing', desc: '', args: []);
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
