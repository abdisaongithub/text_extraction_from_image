import 'package:filesaverz/filesaver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_extraction_from_image/providers/imagePathProvider.dart';
import 'package:text_extraction_from_image/screens/image_picking_screen.dart';

class LandingScreen extends ConsumerStatefulWidget {
  static String id = 'LandingScreen';

  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  bool _picked = false;

  void saveFile({required String text}) async {
    FileSaver fileSaver = FileSaver(
      initialFileName: 'New File',
      fileTypes: const ['.txt'],
    );

    final a = await fileSaver.writeAsString(text, context: context);

    Fluttertoast.showToast(
      msg: "Text file saved at ${a!.parent.path}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = ref.watch(imagePathProvider);

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F1F1),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _picked && text.isEmpty
              ? SingleChildScrollView(
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
                              saveFile(text: text);
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
                )
              : GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      ImagePickingScreen.id,
                    );
                    setState(() {
                      _picked = true;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/img/scan.jpg'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Tap anywhere to scan your text',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
