import 'package:flutter/material.dart';

class NomineePage extends StatelessWidget {
  const NomineePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nominee Management")),
      body: const Center(child: Text("Nominee Management Page")),
    );
  }
}
