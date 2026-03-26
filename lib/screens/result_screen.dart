import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final bool isCorrect;
  const ResultScreen({super.key, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    if (isCorrect) {
      app.addXP(20);
      app.increaseStreak();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isCorrect ? "🎉 صحيح!" : "❌ خطأ"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text("الرجوع للرئيسية"),
            )
          ],
        ),
      ),
    );
  }
}