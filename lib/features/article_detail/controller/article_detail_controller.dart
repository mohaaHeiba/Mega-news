import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

// ================= Enums =================
enum TtsState { playing, stopped, paused, continued }

class ArticleDetailController extends GetxController {
  // ================= Variables & State =================
  Article? article;

  // AI Summary Data
  String? aiSummary;
  String? aiTopic;
  List<String>? aiImages;

  // UI Observables
  var vibrantColor = Rx<Color>(Colors.blue);
  var vibrantTextColor = Rx<Color>(Colors.white);
  var isLiked = false.obs;
  var ttsState = TtsState.stopped.obs;

  // Services
  final FlutterTts _flutterTts = FlutterTts();

  // ================= Initialization =================
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    // Handle Standard Article
    if (args is Article) {
      article = args;
      // Delay slightly to ensure UI is ready before calculating colors
      Future.delayed(const Duration(milliseconds: 100), () {
        _generatePalette();
      });
    }
    // Handle AI Generated Content
    else if (args is Map<String, dynamic>) {
      aiTopic = args['topic'];
      aiSummary = args['summary'];
      aiImages = args['images'];
      vibrantColor.value = Colors.deepPurple;
    }

    _initTts();
  }

  // ================= User Actions =================
  void toggleLike() {
    isLiked.value = !isLiked.value;
  }

  // ================= Text-to-Speech (TTS) Logic =================
  void _initTts() {
    _flutterTts.setSpeechRate(0.45);
    _flutterTts.setLanguage("en-US");

    // Status Listeners
    _flutterTts.setStartHandler(() => ttsState.value = TtsState.playing);
    _flutterTts.setCompletionHandler(() => ttsState.value = TtsState.stopped);
    _flutterTts.setCancelHandler(() => ttsState.value = TtsState.stopped);
    _flutterTts.setPauseHandler(() => ttsState.value = TtsState.paused);
    _flutterTts.setContinueHandler(() => ttsState.value = TtsState.continued);
    _flutterTts.setErrorHandler((msg) => ttsState.value = TtsState.stopped);
  }

  Future<void> speak() async {
    String textToSpeak =
        aiSummary ?? article?.description ?? article?.title ?? "";
    if (textToSpeak.isNotEmpty) await _flutterTts.speak(textToSpeak);
  }

  Future<void> pauseTts() async => await _flutterTts.pause();
  Future<void> stopTts() async => await _flutterTts.stop();

  // ================= External Navigation =================
  Future<void> openArticleLink() async {
    if (article == null) return;
    final uri = Uri.parse(article!.articleUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ================= Dynamic UI & Color Logic =================

  /// Extracts the dominant vibrant color from the article image
  Future<void> _generatePalette() async {
    if (article?.imageUrl == null) return;

    try {
      final ImageProvider provider = NetworkImage(article!.imageUrl!);

      final palette = await PaletteGenerator.fromImageProvider(
        provider,
        size: const Size(100, 100), // Low res for faster calculation
      );

      if (palette.vibrantColor != null) {
        final targetColor = palette.vibrantColor!.color;
        final targetTextColor = palette.vibrantColor!.titleTextColor;

        // Animate to the new color smoothly
        _graduallyChangeColor(vibrantColor.value, targetColor);
        vibrantTextColor.value = targetTextColor;
      }
    } catch (e) {
      debugPrint("Failed to generate palette: $e");
    }
  }

  /// Manually animates color change for smoother visual effect than standard tween
  void _graduallyChangeColor(Color from, Color to) {
    const int steps = 100;
    const Duration stepDuration = Duration(milliseconds: 15);

    double r = from.red.toDouble();
    double g = from.green.toDouble();
    double b = from.blue.toDouble();
    double a = from.opacity;

    double dr = (to.red - r) / steps;
    double dg = (to.green - g) / steps;
    double db = (to.blue - b) / steps;
    double da = (to.opacity - a) / steps;

    int currentStep = 0;

    Timer.periodic(stepDuration, (timer) {
      if (currentStep >= steps) {
        timer.cancel();
        vibrantColor.value = to;
      } else {
        r += dr;
        g += dg;
        b += db;
        a += da;
        vibrantColor.value = Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), a);
        currentStep++;
      }
    });
  }
}
