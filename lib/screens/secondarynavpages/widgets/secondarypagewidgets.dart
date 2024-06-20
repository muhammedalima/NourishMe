import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nourish_me/screens/secondarynavpages/calories/image_calories_screen.dart';
import 'package:nourish_me/constants/Constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nourish_me/main.dart';
import 'package:nourish_me/geminiapi/gemini.dart';

class Nourishnavirecipe extends StatefulWidget {
  const Nourishnavirecipe({super.key});

  @override
  State<Nourishnavirecipe> createState() => _NourishnavirecipeState();
}

class _NourishnavirecipeState extends State<Nourishnavirecipe> {
  bool isloading = false;
  String recipe = '';
  @override
  void initState() {
    isloading = true;
    Geminifunction().Reciepe().then((value) {
      setState(() {
        recipe = value!;
        isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NourishNavi'),
        backgroundColor: Primary_voilet,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 37.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    isloading
                        ? Image.asset(
                            "assets/images/loadingnavi.gif",
                            height: 250,
                            width: 250,
                          )
                        : Image.asset(
                            "assets/images/NourishNavyNobg.png",
                            height: 250,
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    isloading
                        ? Text(
                            'Looking for recipe',
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(
                            recipe,
                            style: TextStyle(color: Colors.white),
                          ),
                    isloading
                        ? Text(
                            'Looking for recipe',
                            style: TextStyle(color: Colors.white),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: Primary_voilet,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isloading = true;
                                  });
                                  final recipe1 =
                                      await Geminifunction().Reciepe();
                                  setState(() {
                                    recipe = recipe1!;
                                    isloading = false;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.restart_alt,
                                      color: Primary_voilet,
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      'Regenerate',
                                      style: TextStyle(
                                        color: Primary_voilet,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CameraAccessWidget extends StatefulWidget {
  final DateTime? selectedDate;
  CameraAccessWidget({
    super.key,
    required this.selectedDate,
  });
  @override
  State<CameraAccessWidget> createState() => _CameraAccessWidgetState();
}

class _CameraAccessWidgetState extends State<CameraAccessWidget> {
  late CameraController cameraController;
  XFile? imageFile;
  int direction = 0;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Camera'),
          backgroundColor: Primary_green,
        ),
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              color: Primary_green,
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 120),
              child: CameraPreview(cameraController),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  cameraController.setFlashMode(FlashMode.off);
                  if (cameraController.value.isInitialized) {
                    final image = await cameraController.takePicture();
                    final bytes = await image.readAsBytes();
                    log("image $image");
                    final File clickedImage = File(image.path);
                    final tempDir = await getTemporaryDirectory();
                    String filePath = tempDir.path;
                    String fileName = DateTime.now().toString();
                    final File localImage =
                        await clickedImage.copy("$filePath/$fileName");
                    log("file : ${localImage.path}");
                    setState(() {
                      print("Clicked");
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ImageCaloriesPage(
                          imagefile: localImage,
                          imageinbytes: bytes,
                          selectedDate: widget.selectedDate!,
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  print(e); //show error
                }
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.photo_camera,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
