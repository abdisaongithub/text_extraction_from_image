import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:text_extraction_from_image/main.dart';
import 'package:text_extraction_from_image/providers/imagePathProvider.dart';

class ImagePickingScreen extends StatefulWidget {
  static String id = 'ImagePickingScreen';

  const ImagePickingScreen({Key? key}) : super(key: key);

  @override
  _ImagePickingScreenState createState() => _ImagePickingScreenState();
}

class _ImagePickingScreenState extends State<ImagePickingScreen> {
  String scannedText = '';
  late CameraController controller;
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return SafeArea(
          top: true,
          child: CameraPreview(
            controller,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Opacity(
                            opacity: 0,
                            child: SizedBox(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final image = await controller.takePicture();
                              ref
                                  .read(imagePathProvider.notifier)
                                  .extractNew(path: image.path);
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                            ),
                          ),
                          SizedBox(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
