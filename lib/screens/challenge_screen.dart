import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../utils/openrouter_service.dart';
import 'result_screen.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  Map<String, dynamic>? questionData;
  int selected = -1;
  bool isLoading = true;
  int totalTime = 60;
  int remainingTime = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  void startTimer() {
    remainingTime = totalTime;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          t.cancel();
          goToResult(-1); // الوقت انتهى
        }
      });
    });
  }

  void loadQuestion() async {
    setState(() => isLoading = true);

    try {
      final data = await OpenRouterService().generateQuestion();

      print("QUESTION DATA: $data"); // 👈 ADD THIS

      setState(() {
        questionData = data;
        selected = -1;
        isLoading = false;
      });

      startTimer();
    } catch (e) {
      print("ERROR 👉 $e"); // 👈 VERY IMPORTANT

      setState(() => isLoading = false);
    }
  }

  void goToResult(int index) {
    timer?.cancel();
    final app = Provider.of<AppState>(context, listen: false);
    final correctIndex = questionData?['correctIndex'] ?? -1;
    final isCorrect = index == correctIndex;

    if (isCorrect) {
      app.addXP(20);
      app.increaseStreak();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(isCorrect: isCorrect),
      ),
    );
  }

  void answer(int index) {
    setState(() => selected = index);
    Future.delayed(const Duration(seconds: 1), () => goToResult(index));
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    /// ✅ Loading
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0A1E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// ❌ If API failed
    if (questionData == null ||
        questionData!['question'] == null ||
        questionData!['options'] == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F0A1E),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "❌ Failed to load question",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loadQuestion,
                child: const Text("Retry"),
              )
            ],
          ),
        ),
      );
    }

    /// ✅ Safe extraction
    final String question = questionData!['question'];
    final List<String> options =
        List<String>.from(questionData!['options']);
    final int correctIndex = questionData!['correctIndex'] ?? -1;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0A1E),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            /// Timer
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: remainingTime / totalTime,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade800,
                    valueColor:
                        const AlwaysStoppedAnimation(Color(0xFF7C3AED)),
                  ),
                ),
                Text(
                  '$remainingTime s',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Question
            Text(
              question,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            /// Answers
            ...List.generate(options.length, (index) {
              final isSelected = selected == index;
              final isCorrect = index == correctIndex;

              return AnimatedScale(
                scale: isSelected ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: () => answer(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isCorrect ? Colors.green : Colors.red)
                          : const Color(0xFF1A1030),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: (isCorrect
                                    ? Colors.green
                                    : Colors.red)
                                .withOpacity(0.5),
                            blurRadius: 15,
                          )
                      ],
                    ),
                    child: Text(
                      options[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            /// XP Bar
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: app.score / 100),
              duration: const Duration(seconds: 1),
              builder: (context, double value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade800,
                  color: const Color(0xFF7C3AED),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}