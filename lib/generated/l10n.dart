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

  /// `Please enter your name.`
  String get enterName {
    return Intl.message(
      'Please enter your name.',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters.`
  String get nameMinChars {
    return Intl.message(
      'Name must be at least 3 characters.',
      name: 'nameMinChars',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address.`
  String get enterEmail {
    return Intl.message(
      'Please enter your email address.',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password.`
  String get enterPassword {
    return Intl.message(
      'Please enter your password.',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters.`
  String get passwordMinChars {
    return Intl.message(
      'Password must be at least 6 characters.',
      name: 'passwordMinChars',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain an uppercase letter and a number.`
  String get passwordUpperNumber {
    return Intl.message(
      'Password must contain an uppercase letter and a number.',
      name: 'passwordUpperNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password.`
  String get confirmPassword {
    return Intl.message(
      'Please confirm your password.',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get passwordsNotMatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'passwordsNotMatch',
      desc: '',
      args: [],
    );
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
