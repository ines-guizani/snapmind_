import 'dart:async';
import 'dart:math';
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
          goToResult(-1);
        }
      });
    });
  }

  void loadQuestion() async {
    setState(() => isLoading = true);
    try {
      final data = await OpenRouterService().generateQuestion();
      setState(() {
        questionData = data;
        selected = -1;
        isLoading = false;
      });
      startTimer();
    } catch (e) {
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
        builder: (_) => ResultScreen(
          isCorrect: isCorrect,
          onNewChallenge: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChallengeScreen()),
            );
          },
        ),
      ),
    );
  }

  void answer(int index) {
    if (selected != -1) return;
    setState(() => selected = index);
    Future.delayed(const Duration(milliseconds: 800), () => goToResult(index));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0A1E),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7C3AED),
          ),
        ),
      );
    }

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
                '❌ Failed to load question',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loadQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final String question = questionData!['question'];
    final List<String> options = List<String>.from(questionData!['options']);
    final int correctIndex = questionData!['correctIndex'] ?? -1;
    final letters = ['A', 'B', 'C', 'D'];

    return Scaffold(
      backgroundColor: const Color(0xFF0F0A1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// Header: back + badge + timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1030),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF7C3AED).withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '←',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),

                  /// Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF7C3AED).withOpacity(0.3),
                      ),
                    ),
                    child: const Text(
                      '🧠 تحدي ذكاء',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFC4B5FD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  /// Timer ring
                  SizedBox(
                    width: 52,
                    height: 52,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(52, 52),
                          painter: _TimerRingPainter(
                            progress: remainingTime / totalTime,
                          ),
                        ),
                        Text(
                          '$remainingTime',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFF59E0B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Progress bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF241840),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.33,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Question card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1030),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'سؤال · AI Generated',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7C3AED),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF5F3FF),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Options
              ...List.generate(options.length, (index) {
                final isSelected = selected == index;
                final isCorrect = index == correctIndex;
                final hasAnswered = selected != -1;

                Color bgColor = const Color(0xFF1A1030);
                Color borderColor = const Color(0xFF7C3AED).withOpacity(0.3);
                Color letterBg = const Color(0xFF241840);
                Color letterColor = const Color(0xFF9CA3AF);
                Color textColor = const Color(0xFFF5F3FF);

                if (hasAnswered && isSelected && isCorrect) {
                  bgColor = const Color(0xFFD1FAE5);
                  borderColor = const Color(0xFF10B981);
                  letterBg = const Color(0xFF10B981);
                  letterColor = Colors.white;
                  textColor = const Color(0xFF065F46);
                } else if (hasAnswered && isSelected && !isCorrect) {
                  bgColor = const Color(0xFFFEE2E2);
                  borderColor = const Color(0xFFEF4444);
                  letterBg = const Color(0xFFEF4444);
                  letterColor = Colors.white;
                  textColor = const Color(0xFF991B1B);
                }

                return GestureDetector(
                  onTap: () => answer(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: letterBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              letters[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: letterColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            options[index],
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  _TimerRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final strokeWidth = 4.0;

    /// Background track
    final bgPaint = Paint()
      ..color = const Color(0xFF241840)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    /// Progress arc
    final paint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter old) => old.progress != progress;
}