import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nourish_me/screens/secondarynavpages/calories/image_calories_screen.dart';
import 'package:nourish_me/theme_library/theme_library.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nourish_me/main.dart';

class CameraAccessWidget extends StatefulWidget {
  DateTime? _selecteddate;
  CameraAccessWidget(DateTime _DateTime) {
    this._selecteddate = _DateTime;
  }

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
                              imagefile: localImage, imageinbytes: bytes)),
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
