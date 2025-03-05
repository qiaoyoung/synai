import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF8A79F9), // Fully opaque theme color
                Color(0x008A79F9), // Fully transparent theme color
              ],
            ),
          ),
        ),
        toolbarHeight: 90,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Introduction'),
            _buildParagraph(
              'Welcome to Synai! This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. Please read this Privacy Policy carefully. By using the application, you consent to the data practices described in this statement.',
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Information We Collect'),
            _buildParagraph(
              'We may collect information about you in various ways, including:',
            ),
            _buildBulletPoint('Personal Data: Name, email address, and profile information you provide.'),
            _buildBulletPoint('Usage Data: Information on how you use the application, including chat history with AI companions.'),
            _buildBulletPoint('Device Data: Information about your mobile device, including device type, operating system, and unique device identifiers.'),
            
            const SizedBox(height: 24),
            _buildSectionTitle('How We Use Your Information'),
            _buildParagraph(
              'We may use the information we collect about you for various purposes, including:',
            ),
            _buildBulletPoint('To provide and maintain our service, including to monitor the usage of our application.'),
            _buildBulletPoint('To manage your account and provide you with customer support.'),
            _buildBulletPoint('To improve our application and user experience.'),
            _buildBulletPoint('To personalize your experience and deliver content relevant to your interests.'),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Disclosure of Your Information'),
            _buildParagraph(
              'We may share information we have collected about you in certain situations. Your information may be disclosed as follows:',
            ),
            _buildBulletPoint('By Law or to Protect Rights: If required by law or if we believe that such action is necessary to comply with the law or protect our rights.'),
            _buildBulletPoint('Third-Party Service Providers: We may share your information with third-party vendors who provide services on our behalf.'),
            _buildBulletPoint('Marketing Communications: With your consent, we may share your information with third parties for marketing purposes.'),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Security of Your Information'),
            _buildParagraph(
              'We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable, and no method of data transmission can be guaranteed against any interception or other type of misuse.',
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Your Choices About Your Information'),
            _buildParagraph(
              'You can choose not to provide certain information, but this may limit your ability to use certain features of the application. You can also:',
            ),
            _buildBulletPoint('Update or correct your personal information at any time.'),
            _buildBulletPoint('Opt-out of receiving promotional communications from us.'),
            _buildBulletPoint('Request deletion of your personal information, subject to certain exceptions.'),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Children\'s Privacy'),
            _buildParagraph(
              'Our application is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we can take necessary actions.',
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Changes to This Privacy Policy'),
            _buildParagraph(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date at the top of this Privacy Policy. You are advised to review this Privacy Policy periodically for any changes.',
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle('Contact Us'),
            _buildParagraph(
              'If you have any questions about this Privacy Policy, please contact us at:',
            ),
            _buildParagraph(
              'Email: privacy@synai.app\nAddress: 123 AI Street, Tech City, TC 12345',
            ),
            
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Last Updated: January 1, 2023',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 