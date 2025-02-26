import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nourish_me/constants/Constants.dart';
import 'package:nourish_me/firebase_options.dart';
import 'package:nourish_me/screens/splash_screen.dart';

late List<CameraDescription> cameras;

void main() async {
  Gemini.init(
    apiKey: Geminiapi,
  );
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    NourishMe(),
  );
}

class NourishMe extends StatelessWidget {
  const NourishMe({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Nourish Me',
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC0DB3F),
            surface: Colors.black,
            background: Colors.black,
          ),
          useMaterial3: true,
        ),
        home: const splashScreen());
  }
}
