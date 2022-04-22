import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_extraction_from_image/providers/imagePathProvider.dart';
import 'package:text_extraction_from_image/screens/image_picking_screen.dart';

class LandingScreen extends ConsumerStatefulWidget {
  static String id = 'LandingScreen';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  Future<String> get _getDirPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  @override
  Widget build(BuildContext context) {
    final text = ref.watch(imagePathProvider);

    return SafeArea(
      top: true,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        if (kDebugMode) {
                          print(await _getDirPath);
                        }
                      },
                      color: Colors.blueGrey,
                      child: const Text('Save'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ImagePickingScreen.id,
                        );
                      },
                      color: Colors.teal,
                      child: const Text('Scan Images'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  text,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
