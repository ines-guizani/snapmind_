import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text("Level: ${app.level}"),
            Text("XP: ${app.score}"),
            Text("Streak: ${app.streak} 🔥"),
          ],
        ),
      ),
    );
  }
}