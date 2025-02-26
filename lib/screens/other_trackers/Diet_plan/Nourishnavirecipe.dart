import 'package:flutter/material.dart';
import 'package:nourish_me/constants/Constants.dart';
import 'package:nourish_me/geminiapi/gemini.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

class Nourishnavirecipe extends StatefulWidget {
  const Nourishnavirecipe({super.key});

  @override
  State<Nourishnavirecipe> createState() => _NourishnavirecipeState();
}

class _NourishnavirecipeState extends State<Nourishnavirecipe> {
  bool isLoading = false;
  bool isError = false;
  String recipe = '';
  String errorMessage = '';
  final ScrollController _scrollController = ScrollController();
  // Add a map to store calories balance
  Map<String, dynamic>? calorieInfo;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await _loadCalorieInfo();
      await _loadRecipe();
    } catch (e) {
      print("Error in initial data loading: $e");
      setState(() {
        isError = true;
        errorMessage = "Failed to load initial data. Please try again.";
      });
    }
  }

  // Method to load calorie information
  Future<void> _loadCalorieInfo() async {
    try {
      // Show loading state immediately
      setState(() {
        isLoading = true;
      });

      final totalCalories = await Geminifunction().getTotalCalorie();
      final recommendedCalories =
          await Geminifunction().getRecommendedCalories();

      // Add some validation to handle potential errors
      final total = int.tryParse(totalCalories) ?? 0;
      final recommended =
          int.tryParse(recommendedCalories) ?? 2000; // Default if invalid

      setState(() {
        calorieInfo = {
          'total': total,
          'recommended': recommended,
          'balance': recommended - total
        };
      });
    } catch (e) {
      print("Error loading calorie info: $e");
      setState(() {
        calorieInfo = {'total': 0, 'recommended': 2000, 'balance': 2000};
      });
    }
  }

  Future<void> _loadRecipe() async {
    setState(() {
      isLoading = true;
      isError = false;
      errorMessage = '';
    });

    try {
      final value = await Geminifunction().Reciepe();

      if (value == null || value.isEmpty) {
        throw Exception("Recipe generation failed");
      }

      setState(() {
        recipe = value;
        isLoading = false;
      });

      // Auto-scroll to top when new recipe loads
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      print("Error generating recipe: $e");
      setState(() {
        isError = true;
        errorMessage =
            "Could not generate recipe. Please check your internet connection and try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'NourishNavi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Primary_voilet,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? _buildLoadingState()
            : isError
                ? _buildErrorState()
                : _buildRecipeContent(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/loadingnavi.gif",
            height: 200,
            width: 200,
          ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
          const SizedBox(height: 30),
          const Text(
            'Creating your personalized recipe...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 300))
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 15),
          SizedBox(
            width: 240,
            child: LinearProgressIndicator(
              backgroundColor: const Color(0xFF2A2A2A),
              valueColor: AlwaysStoppedAnimation<Color>(Primary_voilet),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
          const SizedBox(height: 30),
          Text(
            calorieInfo != null
                ? 'Based on your daily intake of ${calorieInfo!['total']} calories'
                : 'Based on your daily intake of calories',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
        ],
      ),
    );
  }

  // New method to handle error states
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 70,
            color: Colors.red.withOpacity(0.7),
          ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
          const SizedBox(height: 20),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              errorMessage.isNotEmpty
                  ? errorMessage
                  : 'We couldn\'t create your recipe right now. Please try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              _loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Primary_voilet,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Try Again'),
          ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
        ],
      ),
    );
  }

  Widget _buildRecipeContent() {
    // Parse recipe to separate sections for better formatting
    final sections = _parseRecipe(recipe);

    return Column(
      children: [
        // Calorie information banner
        if (calorieInfo != null)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: calorieInfo!['balance'] >= 0
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: calorieInfo!['balance'] >= 0
                    ? Colors.green.withOpacity(0.5)
                    : Colors.orange.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  calorieInfo!['balance'] >= 0
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  color: calorieInfo!['balance'] >= 0
                      ? Colors.green
                      : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    calorieInfo!['balance'] >= 0
                        ? 'You have ${calorieInfo!['balance']} calories remaining today'
                        : 'You\'ve exceeded your daily calories by ${-calorieInfo!['balance']}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 500))
              .slideY(begin: -0.2, end: 0),

        // Recipe content
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Recipe content
                  SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                color: Primary_voilet.withOpacity(0.1),
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  "assets/images/NourishNavyNobg.png",
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sections['title'] ??
                                        "Your Personalized Recipe",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Created just for you by NourishNavi",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (calorieInfo != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        calorieInfo!['balance'] >= 500
                                            ? "Lower calorie recipe recommended"
                                            : calorieInfo!['balance'] <= 0
                                                ? "Light meal option"
                                                : "Balanced meal option",
                                        style: TextStyle(
                                          color:
                                              Primary_voilet.withOpacity(0.8),
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Recipe sections
                        if (sections['ingredients'] != null)
                          _buildSection(
                              "Ingredients", sections['ingredients']!),
                        if (sections['instructions'] != null)
                          _buildSection(
                              "Instructions", sections['instructions']!),
                        if (sections['description'] != null)
                          _buildSection("Story", sections['description']!),
                        if (sections['notes'] != null)
                          _buildSection("Chef's Notes", sections['notes']!),
                        if (sections['allergens'] != null)
                          _buildSection("Allergens", sections['allergens']!),
                        if (sections['nutrition'] != null)
                          _buildSection(
                              "Nutrition Info", sections['nutrition']!),

                        // If we couldn't parse sections, just show the full text
                        if (sections.length <= 1)
                          Text(
                            recipe,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Gradient overlay at top for better scrolling experience
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF1A1A1A),
                            const Color(0xFF1A1A1A).withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.restart_alt,
                  label: "New Recipe",
                  onPressed: () {
                    _loadRecipe();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Improved method to implement sharing functionality with better formatting
  void _shareRecipe(Map<String, String> sections) {
    String shareText = '';

    // Add title with proper formatting
    if (sections['title'] != null) {
      shareText += "🍳 ${sections['title']}\n\n";
    }

    // Add each section with proper emoji and formatting
    if (sections['ingredients'] != null) {
      shareText += "📋 INGREDIENTS:\n${sections['ingredients']}\n\n";
    }

    if (sections['instructions'] != null) {
      shareText += "👨‍🍳 INSTRUCTIONS:\n${sections['instructions']}\n\n";
    }

    if (sections['allergens'] != null) {
      shareText += "⚠️ ALLERGENS:\n${sections['allergens']}\n\n";
    }

    if (sections['nutrition'] != null) {
      shareText += "🥗 NUTRITION:\n${sections['nutrition']}\n\n";
    }

    // Add calorie information if available
    if (calorieInfo != null) {
      shareText += "🔥 CALORIE INFO:\n";
      shareText += "Daily intake: ${calorieInfo!['total']} cal\n";
      shareText += "Recommended: ${calorieInfo!['recommended']} cal\n";
      shareText += "Balance: ${calorieInfo!['balance']} cal\n\n";
    }

    // Add attribution
    shareText +=
        "Created with NourishNavi - Your personalized recipe assistant";

    // Share the text
    Share.share(shareText);
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Primary_voilet.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Primary_voilet,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF232323),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Primary_voilet,
            width: 1.5,
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Primary_voilet,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'About NourishNavi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NourishNavi creates personalized recipes based on your daily caloric intake. The recipes are designed to complement your nutrition goals and provide delicious meal options.',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            if (calorieInfo != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Daily calories consumed:',
                        '${calorieInfo!['total']} cal',
                        icon: Icons.local_fire_department_outlined),
                    const SizedBox(height: 8),
                    _buildInfoRow('Recommended daily intake:',
                        '${calorieInfo!['recommended']} cal',
                        icon: Icons.recommend_outlined),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        'Calorie balance:', '${calorieInfo!['balance']} cal',
                        icon: Icons.balance_outlined,
                        isPositive: calorieInfo!['balance'] >= 0),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got It',
              style: TextStyle(
                color: Primary_voilet,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for info dialog
  Widget _buildInfoRow(String label, String value,
      {IconData? icon, bool? isPositive}) {
    Color valueColor = Colors.white;
    if (isPositive != null) {
      valueColor = isPositive ? Colors.green : Colors.orange;
    }

    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: Colors.white70,
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Improved method to parse recipe text into sections with better regex patterns
  Map<String, String> _parseRecipe(String recipeText) {
    final Map<String, String> sections = {};

    // Try to extract a title - look for the first line that isn't a section header
    final lines = recipeText.split('\n');
    if (lines.isNotEmpty) {
      final firstLine = lines[0].trim();
      // Check if the first line looks like a title (not a section header)
      if (!RegExp(
              r'^(ingredients|instructions|directions|method|steps|story|description|notes|allergens|nutrition|serves):',
              caseSensitive: false)
          .hasMatch(firstLine)) {
        sections['title'] = firstLine;

        // Remove the title from the recipe text for better parsing
        recipeText = lines.sublist(1).join('\n').trim();
      } else {
        // If no title found, create a generic one based on recipe content
        final lowerRecipe = recipeText.toLowerCase();
        if (lowerRecipe.contains("pasta") ||
            lowerRecipe.contains("spaghetti")) {
          sections['title'] = "Pasta Creation";
        } else if (lowerRecipe.contains("chicken")) {
          sections['title'] = "Chicken Delight";
        } else if (lowerRecipe.contains("salad")) {
          sections['title'] = "Fresh Salad Bowl";
        } else if (lowerRecipe.contains("soup")) {
          sections['title'] = "Homemade Soup";
        } else {
          sections['title'] = "Personalized Recipe";
        }
      }
    }

    // Improved regex patterns with more variations and better section capture
    final Map<String, RegExp> sectionPatterns = {
      'ingredients': RegExp(
          r'(?:ingredients|what you will need)[\s:]+(.*?)(?=(?:instructions|directions|method|steps|story|description|notes|allergens|nutrition|serves)[\s:]|$)',
          caseSensitive: false,
          dotAll: true),
      'instructions': RegExp(
          r'(?:instructions|directions|method|steps|preparation|how to make it)[\s:]+(.*?)(?=(?:story|description|notes|allergens|nutrition|serves)[\s:]|$)',
          caseSensitive: false,
          dotAll: true),
      'description': RegExp(
          r'(?:story|travel experience|description|inspiration|about)[\s:]+(.*?)(?=(?:allergens|nutrition|serves|notes)[\s:]|$)',
          caseSensitive: false,
          dotAll: true),
      'notes': RegExp(
          r'(?:notes|chefs notes|tips|cooking tips)[\s:]+(.*?)(?=(?:allergens|nutrition|serves)[\s:]|$)',
          caseSensitive: false,
          dotAll: true),
      'allergens': RegExp(
          r'(?:allergens|potential allergens|allergy info|allergy information)[\s:]+(.*?)(?=(?:nutrition|serves)[\s:]|$)',
          caseSensitive: false,
          dotAll: true),
      'nutrition': RegExp(
          r'(?:nutrition|nutritional information|serves|servings|nutritional facts)[\s:]+(.*?)$',
          caseSensitive: false,
          dotAll: true),
    };

    // Extract each section using the patterns
    sectionPatterns.forEach((key, pattern) {
      final match = pattern.firstMatch(recipeText);
      if (match != null) {
        sections[key] = match.group(1)?.trim() ?? '';
      }
    });

    return sections;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
