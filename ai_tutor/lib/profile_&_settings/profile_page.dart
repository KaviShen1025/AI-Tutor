import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Profile Image Section
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('assets/hexaelite_logo.png'),
                          backgroundColor: Color.fromARGB(255, 224, 224, 231),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Basic Information Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade600,
                                Colors.blue.shade800
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                  Icons.email_outlined, 'john.doe@example.com'),
                              const SizedBox(height: 12),
                              _buildInfoRow(Icons.school_outlined,
                                  'Computer Science Student'),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                  Icons.location_on_outlined, 'New York, USA'),
                              const SizedBox(height: 12),
                              _buildInfoRow(Icons.calendar_today_outlined,
                                  'Joined January 2025'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats Grid
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          physics: const NeverScrollableScrollPhysics(),
                            children: [
                            _buildStatCard(
                              icon: Icons.workspace_premium,
                              title: 'Achievements',
                              value: '15',
                            ),
                            _buildStatCard(
                              icon: Icons.assignment_turned_in,
                              title: 'Completed Tasks',
                              value: '42',
                            ),
                            _buildStatCard(
                              icon: Icons.access_time,
                              title: 'Study Hours',
                              value: '86',
                            ),
                            _buildStatCard(
                              icon: Icons.emoji_events,
                              title: 'Certifications',
                              value: '4',
                            ),
                            _buildStatCard(
                              icon: Icons.groups,
                              title: 'Group Projects',
                              value: '7',
                            ),
                            _buildStatCard(
                              icon: Icons.trending_up,
                              title: 'Progress',
                              value: '92%',
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Performance Metrics
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Performance Metrics',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildProgressMetric('Quiz Success Rate', 0.85),
                                const SizedBox(height: 8),
                                _buildProgressMetric('Course Completion', 0.72),
                                const SizedBox(height: 8),
                                _buildProgressMetric('Assignment Score', 0.90),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32,color:Colors.grey,),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressMetric(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text('${(value * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
