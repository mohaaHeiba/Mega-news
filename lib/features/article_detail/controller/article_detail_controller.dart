import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_news/features/home/controller/home_controller.dart';
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

enum TtsState { playing, stopped, paused, continued }

class ArticleDetailController extends GetxController {
  // إذا كنت تحتاج للوصول للكنترولر الرئيسي (اختياري)
  // final homeController = Get.find<HomeController>();

  late final Article article;

  var vibrantColor = Rx<Color>(Colors.transparent);
  var vibrantTextColor = Rx<Color>(Colors.white);

  // 🔹 1. تعريف متغير الإعجاب هنا بشكل صحيح
  var isLiked = false.obs;

  // متغير لمتابعة حالة الـ TTS
  var ttsState = TtsState.stopped.obs;

  final FlutterTts _flutterTts = FlutterTts();

  @override
  void onInit() {
    super.onInit();
    article = Get.arguments as Article;

    // 🔹 يمكن هنا التحقق مما إذا كان المقال محفوظاً مسبقاً
    // isLiked.value = homeController.checkIfLiked(article);

    Future.delayed(const Duration(milliseconds: 500), () {
      _generatePalette();
    });

    _initTts();
  }

  // 🔹 2. دالة لعمل Toggle (إعجاب / إلغاء إعجاب)
  void toggleLike() {
    isLiked.value = !isLiked.value;
    // هنا يمكنك إضافة كود لحفظ المقال في قاعدة البيانات أو قائمة المفضلة
  }

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }

  // --- TTS Logic ---
  void _initTts() {
    _flutterTts.setSpeechRate(0.45);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _flutterTts.setLanguage("en-US");

    _flutterTts.setStartHandler(() => ttsState.value = TtsState.playing);
    _flutterTts.setCompletionHandler(() => ttsState.value = TtsState.stopped);
    _flutterTts.setCancelHandler(() => ttsState.value = TtsState.stopped);
    _flutterTts.setPauseHandler(() => ttsState.value = TtsState.paused);
    _flutterTts.setContinueHandler(() => ttsState.value = TtsState.continued);
    _flutterTts.setErrorHandler((msg) => ttsState.value = TtsState.stopped);
  }

  Future<void> speak() async {
    final text = article.description ?? article.title;
    if (text.isNotEmpty) await _flutterTts.speak(text);
  }

  Future<void> pauseTts() async => await _flutterTts.pause();
  Future<void> stopTts() async => await _flutterTts.stop();

  // --- Colors & Links ---
  Future<void> openArticleLink() async {
    final uri = Uri.parse(article.articleUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Error', 'Could not open the link.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not open the link: $e');
    }
  }

  Future<void> _generatePalette() async {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) return;
    try {
      final provider = NetworkImage(article.imageUrl!);
      final palette = await PaletteGenerator.fromImageProvider(
        provider,
        size: const Size(100, 100),
      );
      if (palette.vibrantColor != null) {
        final targetColor = palette.vibrantColor!.color;
        final targetTextColor = palette.vibrantColor!.titleTextColor;
        _graduallyChangeColor(vibrantColor.value, targetColor);
        vibrantTextColor.value = targetTextColor;
      }
    } catch (e) {
      debugPrint("Failed to generate palette: $e");
    }
  }

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
