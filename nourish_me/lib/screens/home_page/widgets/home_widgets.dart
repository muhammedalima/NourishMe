import 'package:flutter/material.dart';
import 'package:nourish_me/theme%20library/theme_library.dart';

class AddCard extends StatelessWidget {
  final String headingTitle;
  final String headingInsideCard;
  final String subHeadingCard;

  const AddCard({
    super.key,
    required this.headingTitle,
    required this.headingInsideCard,
    required this.subHeadingCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Space before text
        const SizedBox(height: 30.0),

        // Text with padding
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 37.0),
          child: Text(
            headingTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                  onPressed: () {},
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
