import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback? onNewChallenge;
  const ResultScreen({super.key, required this.isCorrect, this.onNewChallenge});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0A1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),

              /// Hero emoji + title
              Column(
                children: [
                  Text(
                    isCorrect ? '🎉' : '❌',
                    style: const TextStyle(fontSize: 56),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isCorrect ? 'ممتاز!' : 'للأسف!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF5F3FF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCorrect ? 'إجابة صحيحة! +20 XP' : 'الإجابة خاطئة',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Stats card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E0A3C), Color(0xFF2D1060)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      value: '+${isCorrect ? 20 : 0}',
                      label: 'XP مكتسب',
                      color: const Color(0xFFF59E0B),
                    ),
                    _StatItem(
                      value: isCorrect ? '100%' : '0%',
                      label: 'دقة الإجابة',
                      color: const Color(0xFF10B981),
                    ),
                    _StatItem(
                      value: '${app.level}',
                      label: 'المستوى',
                      color: const Color(0xFFC4B5FD),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Motivational message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF7C3AED).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  isCorrect
                      ? '🧠 "الذكاء ليس عطاء، بل هو تمرين يومي. استمر!"'
                      : '💪 "كل خطأ هو خطوة نحو التحسن. حاول مجدداً!"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFC4B5FD),
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(),

              /// Action buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1030),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF7C3AED).withOpacity(0.3),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '🏠 الرئيسية',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF5F3FF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        if (onNewChallenge != null) {
                          onNewChallenge!();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '⚡ تحدي جديد!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatItem(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}