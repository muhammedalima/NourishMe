import 'package:flutter/material.dart';
import 'package:nourish_me/theme%20library/theme_library.dart';

class homeScreenPage extends StatelessWidget {
  const homeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Space before text
        const SizedBox(height: 30.0),

        // Text with padding
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 37.0),
          child: Text(
            'Life Style',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),

        // Card with content
        Card(
          margin: EdgeInsets.symmetric(horizontal: 37.0),
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
                      padding: EdgeInsets.all(10),
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: const CircularProgressIndicator(
                        value: 0.3,
                        backgroundColor: Colors.white,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '53/Kcal',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Gain 3kg',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w800,
                              color: primary_),
                        ),
                      ],
                    ),
                  ],
                ),

                // Elevated button
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(36, 36),
                    backgroundColor: Colors.black,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8.0),
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
