import 'package:flutter/material.dart';
import 'account_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildSettingsItem(String title, Widget? trailing, VoidCallback onTap,
      {IconData? leadingIcon}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: leadingIcon != null
            ? Icon(leadingIcon, color: Colors.blue.shade700)
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade900,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Text(
                'Customize Your Experience',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingsItem(
              'Account Settings',
              const Icon(Icons.chevron_right, color: Colors.blue),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountSettingsPage()),
                );
              },
              leadingIcon: Icons.person_outline,
            ),
            _buildSettingsItem(
              'Notifications',
              Switch(
                value: true,
                onChanged: (value) {},
                activeColor: Colors.blue.shade600,
              ),
              () {},
              leadingIcon: Icons.notifications_outlined,
            ),
            _buildSettingsItem(
              'Language & Region',
              const Icon(Icons.chevron_right, color: Colors.blue),
              () {},
              leadingIcon: Icons.language_outlined,
            ),
            _buildSettingsItem(
              'Privacy Settings',
              const Icon(Icons.chevron_right, color: Colors.blue),
              () {},
              leadingIcon: Icons.privacy_tip_outlined,
            ),
            _buildSettingsItem(
              'About',
              const Icon(Icons.chevron_right, color: Colors.blue),
              () {},
              leadingIcon: Icons.info_outline,
            ),
            _buildSettingsItem(
              'Logout',
              const Icon(Icons.chevron_right, color: Colors.blue),
              () {},
              leadingIcon: Icons.logout_outlined,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
