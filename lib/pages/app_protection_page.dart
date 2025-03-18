import 'package:flutter/material.dart';

class AppProtectionPage extends StatelessWidget {
  const AppProtectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Protection"),
        backgroundColor: Colors.purple,
      ),
      body: const Center(child: Text("App Protection Page")),
    );
  }
}
