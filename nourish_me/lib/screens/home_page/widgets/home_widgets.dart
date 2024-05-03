import 'package:flutter/material.dart';

import 'package:nourish_me/theme_library/theme_library.dart';
import 'dart:math' as math;

class AddCard extends StatelessWidget {
  final String headingTitle;
  final String headingInsideCard;
  final String subHeadingCard;
  final Widget screens;
  final double progressindex;

  const AddCard({
    super.key,
    required this.progressindex,
    required this.headingTitle,
    required this.headingInsideCard,
    required this.subHeadingCard,
    required this.screens,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Space before text
        const SizedBox(height: 20.0),

        // Text with padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37.0),
          child: Text(
            headingTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // Card with content
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 37.0),
          color: Primary_green,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Progress indicator row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: CircularProgressIndicator(
                        value: progressindex,
                        backgroundColor: Colors.white,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headingInsideCard,
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          subHeadingCard,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF707070),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Elevated button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => screens));
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(36, 36),
                    backgroundColor: Colors.black,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SquareBox extends StatelessWidget {
  final String heading;
  final Color boxcolor;
  final Widget screens;
  const SquareBox({
    super.key,
    required this.heading,
    required this.boxcolor,
    required this.screens,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: boxcolor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                heading,
                style: TextStyle(
                  color: (boxcolor == const Color(0xFFC0DB3F))
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              const Expanded(child: SizedBox(height: 30)),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => screens));
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(36, 36),
                  backgroundColor: Colors.black,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8.0),
                ),
                child: Transform.rotate(
                  angle: 330 * math.pi / 180,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/Loading.gif",
        width: double.infinity,
      ),
    );
  }
}
