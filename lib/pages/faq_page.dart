import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.purple, title: const Text("FAQ")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFAQItem(
            "How does Cognitive App secure my apps?",
            "Cognitive App provides multiple layers of security, including:\n"
                "- App Lock – Lock apps using PIN, pattern, fingerprint, or face recognition.\n"
                "- Intruder Alert – Captures photos of failed login attempts.\n"
                "- Data Encryption – Encrypts sensitive files for extra protection.\n"
                "- Stealth Mode – Hides the app icon to prevent detection.\n"
                "- Anti-Uninstall Protection – Stops unauthorized removal of the app.",
          ),
          _buildFAQItem(
            "How do I lock an app with Cognitive App?",
            "1. Open Cognitive App.\n"
                "2. Select the apps you want to protect.\n"
                "3. Choose your preferred lock method (PIN, pattern, fingerprint, etc.).\n"
                "4. Enable protection, and your apps are now secure.",
          ),
          _buildFAQItem(
            "What happens if I forget my password?",
            "You can reset your password using:\n"
                "- Security Questions (if previously set up).\n"
                "- Email Verification (a reset link will be sent to your registered email).\n"
                "- Backup Code (if you generated one earlier).",
          ),
          _buildFAQItem(
            "Will Cognitive App slow down my phone?",
            "No, Cognitive App is optimized to run in the background with minimal battery and performance impact. It ensures security without slowing down your device.",
          ),
          _buildFAQItem(
            "Can I hide Cognitive App from my home screen?",
            "Yes! You can enable Stealth Mode, which hides the app icon and allows access only through a secret dial code or a disguised calculator interface.",
          ),
          _buildFAQItem(
            "Is Cognitive App free?",
            "Cognitive App offers both free and premium versions:\n"
                "- Free Version – Basic app locking and security features.\n"
                "- Premium Version – Advanced security, cloud backup, fake cover screens, and more.",
          ),
          _buildFAQItem(
            "How do I prevent unauthorized uninstallation?",
            "To enable Uninstall Protection:\n"
                "1. Open Cognitive App > Settings.\n"
                "2. Enable Uninstall Protection.\n"
                "3. If someone tries to uninstall the app, they will be required to enter your password.",
          ),
          _buildFAQItem(
            "Does Cognitive App work on all Android and iOS devices?",
            "Yes, Cognitive App is compatible with most Android and iOS devices. Some features may vary depending on the operating system.",
          ),
          _buildFAQItem(
            "Contact Us",
            "For support or inquiries, reach out to us at cognitiveapp2@gmail.com.",
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(answer, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}
