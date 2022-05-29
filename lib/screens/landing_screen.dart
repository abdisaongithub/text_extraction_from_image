import 'package:filesaverz/filesaverz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_extraction_from_image/providers/imagePathProvider.dart';
import 'package:text_extraction_from_image/screens/image_picking_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingScreen extends ConsumerStatefulWidget {
  static String id = 'LandingScreen';

  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  void saveFile({required String text}) async {
    FileSaver fileSaver = FileSaver(
      initialFileName: 'New File',
      fileTypes: const ['.txt'],
    );

    final a = await fileSaver.writeAsString(text, context: context);

    ref.read(imagePathProvider.notifier).clearField();

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

  void _launchUrl() async {
    final Uri url = Uri.parse('https://t.me/abd_dba');
    canLaunchUrl(url).then((bool result) {
      if (result) {
        try {
          launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          Fluttertoast.showToast(
            msg: 'Could not launch $url',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        debugPrint('Couldn\'t Launch URL');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = ref.watch(imagePathProvider);

    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F1F1),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: text.isNotEmpty
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              text,
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F1F1),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  saveFile(text: text);
                                },
                                child: Container(
                                  color: Colors.deepPurple.withOpacity(0.75),
                                  child: const Center(
                                    child: Text('Save'),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, ImagePickingScreen.id);
                                },
                                child: Container(
                                  color: Colors.deepOrange.withOpacity(0.75),
                                  child: const Center(
                                    child: Text('Scan Text'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      ImagePickingScreen.id,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _launchUrl();
                        },
                        child: const Text(
                          'Contact Developer',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset('assets/img/scan.jpg'),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Tap on the image to scan your text',
                        textAlign: TextAlign.center,
                        maxLines: 2,
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
