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

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Appearance`
  String get appearance {
    return Intl.message('Appearance', name: 'appearance', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Enable Notifications`
  String get enableNotifications {
    return Intl.message(
      'Enable Notifications',
      name: 'enableNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Breaking News`
  String get breakingNews {
    return Intl.message(
      'Breaking News',
      name: 'breakingNews',
      desc: '',
      args: [],
    );
  }

  /// `Enable Breaking News Alerts`
  String get enableBreakingNews {
    return Intl.message(
      'Enable Breaking News Alerts',
      name: 'enableBreakingNews',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `Font Size`
  String get fontSize {
    return Intl.message('Font Size', name: 'fontSize', desc: '', args: []);
  }

  /// `Small`
  String get small {
    return Intl.message('Small', name: 'small', desc: '', args: []);
  }

  /// `Medium`
  String get medium {
    return Intl.message('Medium', name: 'medium', desc: '', args: []);
  }

  /// `Large`
  String get large {
    return Intl.message('Large', name: 'large', desc: '', args: []);
  }

  /// `Clear Cache`
  String get clearCache {
    return Intl.message('Clear Cache', name: 'clearCache', desc: '', args: []);
  }

  /// `Clear cached data to free up space`
  String get clearCacheDescription {
    return Intl.message(
      'Clear cached data to free up space',
      name: 'clearCacheDescription',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `App Version`
  String get appVersion {
    return Intl.message('App Version', name: 'appVersion', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message('Log Out', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to log out?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Cache Cleared`
  String get cacheCleared {
    return Intl.message(
      'Cache Cleared',
      name: 'cacheCleared',
      desc: '',
      args: [],
    );
  }

  /// `Cache has been cleared successfully`
  String get cacheClearedMessage {
    return Intl.message(
      'Cache has been cleared successfully',
      name: 'cacheClearedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Member Since`
  String get memberSince {
    return Intl.message(
      'Member Since',
      name: 'memberSince',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Saved Articles`
  String get savedArticles {
    return Intl.message(
      'Saved Articles',
      name: 'savedArticles',
      desc: '',
      args: [],
    );
  }

  /// `No Saved Articles`
  String get noSavedArticles {
    return Intl.message(
      'No Saved Articles',
      name: 'noSavedArticles',
      desc: '',
      args: [],
    );
  }

  /// `Articles you save will appear here`
  String get articlesYouSaveWillAppearHere {
    return Intl.message(
      'Articles you save will appear here',
      name: 'articlesYouSaveWillAppearHere',
      desc: '',
      args: [],
    );
  }

  /// `Clear All`
  String get clearAll {
    return Intl.message('Clear All', name: 'clearAll', desc: '', args: []);
  }

  /// `Clear All Favorites?`
  String get clearAllFavorites {
    return Intl.message(
      'Clear All Favorites?',
      name: 'clearAllFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove all saved articles? This action cannot be undone.`
  String get clearAllFavoritesMessage {
    return Intl.message(
      'Are you sure you want to remove all saved articles? This action cannot be undone.',
      name: 'clearAllFavoritesMessage',
      desc: '',
      args: [],
    );
  }

  /// `Remove from favorites`
  String get removeFromFavorites {
    return Intl.message(
      'Remove from favorites',
      name: 'removeFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Add to favorites`
  String get addToFavorites {
    return Intl.message(
      'Add to favorites',
      name: 'addToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Removed from Favorites`
  String get removedFromFavorites {
    return Intl.message(
      'Removed from Favorites',
      name: 'removedFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Article removed from your favorites`
  String get articleRemovedFromFavorites {
    return Intl.message(
      'Article removed from your favorites',
      name: 'articleRemovedFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Added to Favorites`
  String get addedToFavorites {
    return Intl.message(
      'Added to Favorites',
      name: 'addedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Article saved to your favorites`
  String get articleSavedToFavorites {
    return Intl.message(
      'Article saved to your favorites',
      name: 'articleSavedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Removed`
  String get removed {
    return Intl.message('Removed', name: 'removed', desc: '', args: []);
  }

  /// `Article removed from favorites`
  String get articleRemovedFromFavoritesShort {
    return Intl.message(
      'Article removed from favorites',
      name: 'articleRemovedFromFavoritesShort',
      desc: '',
      args: [],
    );
  }

  /// `Cleared`
  String get cleared {
    return Intl.message('Cleared', name: 'cleared', desc: '', args: []);
  }

  /// `All favorites have been cleared`
  String get allFavoritesCleared {
    return Intl.message(
      'All favorites have been cleared',
      name: 'allFavoritesCleared',
      desc: '',
      args: [],
    );
  }

  /// `No user data found`
  String get noUserDataFound {
    return Intl.message(
      'No user data found',
      name: 'noUserDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Mega News`
  String get megaNews {
    return Intl.message('Mega News', name: 'megaNews', desc: '', args: []);
  }

  /// `Featured`
  String get featured {
    return Intl.message('Featured', name: 'featured', desc: '', args: []);
  }

  /// `Latest`
  String get latest {
    return Intl.message('Latest', name: 'latest', desc: '', args: []);
  }

  /// `See all`
  String get seeAll {
    return Intl.message('See all', name: 'seeAll', desc: '', args: []);
  }

  /// `No news found`
  String get noNewsFound {
    return Intl.message(
      'No news found',
      name: 'noNewsFound',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get sports {
    return Intl.message('Sports', name: 'sports', desc: '', args: []);
  }

  /// `Technology`
  String get technology {
    return Intl.message('Technology', name: 'technology', desc: '', args: []);
  }

  /// `Business`
  String get business {
    return Intl.message('Business', name: 'business', desc: '', args: []);
  }

  /// `Health`
  String get health {
    return Intl.message('Health', name: 'health', desc: '', args: []);
  }

  /// `Science`
  String get science {
    return Intl.message('Science', name: 'science', desc: '', args: []);
  }

  /// `Entertainment`
  String get entertainment {
    return Intl.message(
      'Entertainment',
      name: 'entertainment',
      desc: '',
      args: [],
    );
  }

  /// `Error Loading News`
  String get errorLoadingNews {
    return Intl.message(
      'Error Loading News',
      name: 'errorLoadingNews',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get anErrorOccurred {
    return Intl.message(
      'An error occurred',
      name: 'anErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Error Searching`
  String get errorSearching {
    return Intl.message(
      'Error Searching',
      name: 'errorSearching',
      desc: '',
      args: [],
    );
  }

  /// `No Results`
  String get noResults {
    return Intl.message('No Results', name: 'noResults', desc: '', args: []);
  }

  /// `Search for articles first to summarize them.`
  String get searchForArticlesFirst {
    return Intl.message(
      'Search for articles first to summarize them.',
      name: 'searchForArticlesFirst',
      desc: '',
      args: [],
    );
  }

  /// `Summarization Failed`
  String get summarizationFailed {
    return Intl.message(
      'Summarization Failed',
      name: 'summarizationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Failed to generate briefings`
  String get failedToGenerateBriefings {
    return Intl.message(
      'Failed to generate briefings',
      name: 'failedToGenerateBriefings',
      desc: '',
      args: [],
    );
  }

  /// `No recent news found to summarize for this topic.`
  String get noRecentNewsFound {
    return Intl.message(
      'No recent news found to summarize for this topic.',
      name: 'noRecentNewsFound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to generate summary`
  String get failedToGenerateSummary {
    return Intl.message(
      'Failed to generate summary',
      name: 'failedToGenerateSummary',
      desc: '',
      args: [],
    );
  }

  /// `View AI Summary`
  String get viewAiSummary {
    return Intl.message(
      'View AI Summary',
      name: 'viewAiSummary',
      desc: '',
      args: [],
    );
  }

  /// `AI Briefing`
  String get ai_briefing {
    return Intl.message('AI Briefing', name: 'ai_briefing', desc: '', args: []);
  }

  /// `Could not generate summary due to an error.`
  String get ai_summary_error {
    return Intl.message(
      'Could not generate summary due to an error.',
      name: 'ai_summary_error',
      desc: '',
      args: [],
    );
  }

  /// `Generation Failed`
  String get generation_failed_title {
    return Intl.message(
      'Generation Failed',
      name: 'generation_failed_title',
      desc: '',
      args: [],
    );
  }

  /// `Could not generate summary. Please try again.`
  String get generation_failed_msg {
    return Intl.message(
      'Could not generate summary. Please try again.',
      name: 'generation_failed_msg',
      desc: '',
      args: [],
    );
  }

  /// `Analyzing...`
  String get status_analyzing {
    return Intl.message(
      'Analyzing...',
      name: 'status_analyzing',
      desc: '',
      args: [],
    );
  }

  /// `Briefing Ready`
  String get status_briefing_ready {
    return Intl.message(
      'Briefing Ready',
      name: 'status_briefing_ready',
      desc: '',
      args: [],
    );
  }

  /// `Generate Summary`
  String get action_generate_summary {
    return Intl.message(
      'Generate Summary',
      name: 'action_generate_summary',
      desc: '',
      args: [],
    );
  }

  /// `What would you like to\nsummarize today?`
  String get ai_welcome_message {
    return Intl.message(
      'What would you like to\nsummarize today?',
      name: 'ai_welcome_message',
      desc: '',
      args: [],
    );
  }

  /// `Account Info`
  String get account_info {
    return Intl.message(
      'Account Info',
      name: 'account_info',
      desc: '',
      args: [],
    );
  }

  /// `Quick Actions`
  String get quick_actions {
    return Intl.message(
      'Quick Actions',
      name: 'quick_actions',
      desc: '',
      args: [],
    );
  }

  /// `read`
  String get read {
    return Intl.message('read', name: 'read', desc: '', args: []);
  }

  /// `Cache Cleared`
  String get cache_cleared_title {
    return Intl.message(
      'Cache Cleared',
      name: 'cache_cleared_title',
      desc: '',
      args: [],
    );
  }

  /// `Cache has been cleared successfully`
  String get cache_cleared_msg {
    return Intl.message(
      'Cache has been cleared successfully',
      name: 'cache_cleared_msg',
      desc: '',
      args: [],
    );
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
