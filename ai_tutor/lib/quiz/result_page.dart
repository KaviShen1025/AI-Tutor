import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_background.dart';
import '../feature/certificate_page.dart';

class ResultPage extends StatelessWidget {
  final String section;
  final int score;
  final int totalQuestions;

  const ResultPage({
    super.key,
    required this.section,
    required this.score,
    required this.totalQuestions,
  });

  double get percentage => (score / totalQuestions) * 100;

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
            children: [
              const AppHeader(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Stars and percentage
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/hexaelite_logo.png',
                          width: 120,
                          height: 120,
                          color: Colors.amber.withOpacity(0.1),
                        ),
                        Column(
                          children: [
                            Text(
                              '${percentage.round()}%',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 24),
                                Icon(Icons.star, color: Colors.amber, size: 24),
                                Icon(Icons.star, color: Colors.amber, size: 24),
                                Icon(Icons.star, color: Colors.amber, size: 24),
                                Icon(Icons.star_half,
                                    color: Colors.amber, size: 24),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Congratulation you got ${percentage.round()}%\nmark from the quiz...',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      'Click here to Generate Your\nCertificate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: 280,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CertificatePage(
                                  section: section,
                                  score: score,
                                  totalQuestions: totalQuestions,
                                  percentage: percentage,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Generate Certificate'),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
