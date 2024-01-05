import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ứng dụng'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/myassets/logo_capstone.png',
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
              const Text(
                'Từ Tâm',
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Phiên bản 0.0',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
