import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

final imagePathProvider =
    StateNotifierProvider<ImagePathNotifier, String>((ref) {
  return ImagePathNotifier();
});

class ImagePathNotifier extends StateNotifier<String> {
  ImagePathNotifier() : super('');
  String content = '';
  TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);
  late InputImage inputImage;

  extractNew({required String path}) async {
    inputImage = InputImage.fromFile(File(path));
    final recognized = await textRecognizer.processImage(inputImage);

    state = state + recognized.text;

    if (await Vibrate.canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }

    Fluttertoast.showToast(
      msg: "Image Scanned, Move on to the next Page",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  clearField() {
    state = '';
    Fluttertoast.showToast(
      msg: "File Saved to disk",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
