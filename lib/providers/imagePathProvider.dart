import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

final imagePathProvider =
    StateNotifierProvider<ImagePathNotifier, String>((ref) {
  return ImagePathNotifier();
});

class ImagePathNotifier extends StateNotifier<String> {
  ImagePathNotifier() : super('\n');
  String content = '';
  TextRecognizer textRecognizer = GoogleMlKit.vision.textRecognizer();
  late InputImage inputImage;

  addPath({required String path}) async {
    inputImage = InputImage.fromFile(File(path));
    final recognized = await textRecognizer.processImage(inputImage);
    state = state + recognized.text;
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
}
