import 'package:flutter/material.dart';
import 'package:ai_tutor/models/course_models.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import 'content_page.dart';
import '../widgets/animated_background.dart';

class ContentPreviewPage extends StatelessWidget {
  final CourseResponse courseData;

  const ContentPreviewPage({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        primaryColor: Colors.blue.shade400,
        secondaryColor: Colors.blue.shade600,
        opacity: 0.03,
        enableWaves: true,
        enableParticles: true,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Content Card
                      Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image Container
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                image: DecorationImage(
                                  image: const AssetImage(
                                      'assets/mountain_bg.jpg'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.1),
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Back Button
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  // Favorite Button
                                  Positioned(
                                    top: 16,
                                    right: 16,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.favorite,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Content Section
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courseData.courseTitle,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Rating Row (Keep as is for now, can be made dynamic later if needed)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        '4.5', // Placeholder
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '(Generated Content)', // Placeholder
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {},
                                        child: Row(
                                          children: [
                                            const Text('Show More'),
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.keyboard_arrow_right,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    courseData.courseDescription,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // "Read more" can be removed or made dynamic if description is long
                                  // For now, let's keep it simple and remove it.
                                  // GestureDetector(
                                  //   onTap: () {},
                                  //   child: Text(
                                  //     'Read more',
                                  //     style: TextStyle(
                                  //       color: Colors.blue[700],
                                  //       fontWeight: FontWeight.w500,
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(height: 24),
                                  // Course Introduction
                                  if (courseData.courseIntroduction.isNotEmpty) ...[
                                    const Text(
                                      'Introduction',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      courseData.courseIntroduction,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                  const Text(
                                    'Table of Content',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Icons Grid
                                  Center(
                                    child: Wrap(
                                      spacing: 16,
                                      runSpacing: 16,
                                      children: courseData.modules.map((module) {
                                        return _buildContentIcon(
                                          Icons.article_outlined, // Default icon for all modules
                                          module.moduleTitle,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[100],
                                            foregroundColor: Colors.grey[800],
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.refresh,
                                                  size: 20),
                                              const SizedBox(width: 8),
                                              const Text('Regenerate'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                              // TODO: Decide what "Continue" does.
                                              // For now, it might navigate to the first module,
                                              // or this button could be context-dependent.
                                              // If courseData.modules is not empty, navigate to ContentPage with first module's data
                                              if (courseData.modules.isNotEmpty) {
                                                // Placeholder: For now, ContentPage may not be ready to accept specific module data.
                                                // This navigation might need to be updated in a future task.
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ContentPage(/* moduleData: courseData.modules.first */),
                                                  ),
                                                );
                                              } else {
                                                 ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('No modules available to continue.')),
                                                );
                                              }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text('Continue'),
                                              const SizedBox(width: 8),
                                              const Icon(Icons.arrow_forward,
                                                  color: Colors.white,
                                                  size: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildContentIcon(IconData icon, String label) {
    return Container(
      width: 100,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 24,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
