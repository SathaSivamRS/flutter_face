import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Choose Your Plan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Free Plan
            _buildSubscriptionCard(
              title: "Free Plan",
              price: "₹0 / month",
              features: [
                "✔ Basic App Lock",
                "✔ Limited Security Features",
                "✔ Ads Supported",
              ],
              isPremium: false,
            ),
            const SizedBox(height: 15),

            // Premium Plan
            _buildSubscriptionCard(
              title: "Premium Plan",
              price: "₹199 / month",
              features: [
                "✔ Advanced Security",
                "✔ No Ads",
                "✔ Cloud Backup",
                "✔ Intruder Alert",
                "✔ Stealth Mode",
                "✔ Fake Cover Screens",
              ],
              isPremium: true,
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Subscription Card
  Widget _buildSubscriptionCard({
    required String title,
    required String price,
    required List<String> features,
    required bool isPremium,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isPremium ? Colors.purple.shade100 : Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isPremium ? Colors.purple : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(price, style: const TextStyle(fontSize: 18)),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) => Text(feature)).toList(),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle Subscription Purchase Logic
                  if (isPremium) {
                    // Implement payment or subscription logic here
                    print("Subscribed to Premium Plan");
                  } else {
                    print("Using Free Plan");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPremium ? Colors.purple : Colors.grey,
                ),
                child: Text(isPremium ? "Get Premium" : "Use Free Plan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
