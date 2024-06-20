import 'package:flutter/material.dart';
import 'package:nourish_me/constants/Constants.dart';
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
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isloading
                        ? Column(
                            children: [
                              Image.asset(
                                "assets/images/loadingnavi.gif",
                                height: 250,
                                width: 250,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Looking for recipe...',
                                style: TextStyle(color: Colors.white30),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Image.asset(
                                "assets/images/NourishNavyNobg.png",
                                height: 250,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                recipe,
                                style: TextStyle(color: Colors.white),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
