import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:mega_news/features/news/domain/entities/article.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mega_news/features/favorites/presentation/controller/favorites_controller.dart';

enum TtsState { playing, stopped, paused, continued }

class ArticleDetailController extends GetxController {
  // ================= Variables & State =================
  Article? article;

  final FavoritesController _favoritesController =
      Get.find<FavoritesController>();

  // AI Summary Data (Legacy support if needed)
  String? aiSummary;
  String? aiTopic;
  List<String>? aiImages;

  // UI Observables
  var vibrantColor = Rx<Color>(Colors.transparent);
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

    // Handle Standard Article (And AI Summary converted to Article)
    if (args is Article) {
      article = args;

      if (article != null) {
        isLiked.value = _favoritesController.isFavorite(article!.id);
      }

      Future.delayed(const Duration(milliseconds: 50), () {
        _generatePalette();
      });
    }
    // Handle AI Generated Content (Legacy Map)
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
    if (article == null) return;

    _favoritesController.toggleFavorite(article!);

    isLiked.value = _favoritesController.isFavorite(article!.id);
  }

  // ================= Text-to-Speech (TTS) Logic =================
  void _initTts() {
    _flutterTts.setSpeechRate(0.5);

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

    if (textToSpeak.isNotEmpty) {
      bool isArabic = RegExp("[\u0600-\u06FF]").hasMatch(textToSpeak);

      if (isArabic) {
        await _flutterTts.setLanguage("ar");
        await _flutterTts.setSpeechRate(0.5);
      } else {
        await _flutterTts.setLanguage("en-US");
        await _flutterTts.setSpeechRate(0.45);
      }

      await _flutterTts.speak(textToSpeak);
    }
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
  Future<void> _generatePalette() async {
    if (article?.imageUrl == null) return;

    try {
      final String imagePath = article!.imageUrl!;
      Uint8List imageBytes;

      final bool isNetworkImage = imagePath.startsWith('http');

      if (isNetworkImage) {
        final networkImage = await NetworkAssetBundle(
          Uri.parse(imagePath),
        ).load(imagePath);
        imageBytes = networkImage.buffer.asUint8List();
      } else {
        final byteData = await rootBundle.load(imagePath);
        imageBytes = byteData.buffer.asUint8List();
      }

      final color = await compute(_extractDominantColor, imageBytes);
      _graduallyChangeColor(vibrantColor.value, color);

      vibrantTextColor.value = color.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
    } catch (e) {
      debugPrint("Failed to extract dominant color: $e");
    }
  }

  static Color _extractDominantColor(Uint8List bytes) {
    final img.Image? decoded = img.decodeImage(bytes);

    if (decoded == null) return Colors.grey;

    int r = 0, g = 0, b = 0;
    int count = 0;

    for (final pixel in decoded) {
      r += pixel.r.toInt();
      g += pixel.g.toInt();
      b += pixel.b.toInt();
      count++;
    }

    if (count == 0) return Colors.grey;

    return Color.fromRGBO(r ~/ count, g ~/ count, b ~/ count, 1);
  }

  void _graduallyChangeColor(Color from, Color to) {
    const int steps = 100;
    const Duration stepDuration = Duration(milliseconds: 10);

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

  @override
  void onClose() {
    _flutterTts.stop();
    super.onClose();
  }
}
