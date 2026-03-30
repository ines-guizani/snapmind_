import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    return app.isLoggedIn ? const _ProfileView() : const _SignInView();
  }
}

// ─────────────────────────────────────────────
// SIGN-IN VIEW
// ─────────────────────────────────────────────
class _SignInView extends StatefulWidget {
  const _SignInView();

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _isSignUp = false;
  String? _error;

  void _submit() {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    if (name.isEmpty || email.isEmpty) {
      setState(() => _error = 'يرجى ملء جميع الحقول');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = 'البريد الإلكتروني غير صحيح');
      return;
    }

    Provider.of<AppState>(context, listen: false).signIn(name, email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Logo
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text('🧠', style: TextStyle(fontSize: 32)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: Text(
                _isSignUp ? 'إنشاء حساب' : 'تسجيل الدخول',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF5F3FF),
                ),
              ),
            ),

            const SizedBox(height: 6),

            Center(
              child: Text(
                _isSignUp
                    ? 'انضم إلى SnapMind وابدأ رحلتك!'
                    : 'مرحباً بعودتك إلى SnapMind 👋',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),

            const SizedBox(height: 36),

            /// Name field
            _InputLabel(label: 'الاسم'),
            const SizedBox(height: 8),
            _InputField(
              controller: _nameCtrl,
              hint: 'Ahmed Khalil',
              icon: Icons.person_outline_rounded,
            ),

            const SizedBox(height: 16),

            /// Email field
            _InputLabel(label: 'البريد الإلكتروني'),
            const SizedBox(height: 8),
            _InputField(
              controller: _emailCtrl,
              hint: 'ahmed@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEF4444).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Color(0xFFEF4444), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      _error!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            /// Submit button
            GestureDetector(
              onTap: _submit,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _isSignUp ? '🚀 إنشاء الحساب' : '⚡ تسجيل الدخول',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Toggle sign-in / sign-up
            Center(
              child: GestureDetector(
                onTap: () => setState(() {
                  _isSignUp = !_isSignUp;
                  _error = null;
                }),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                    children: [
                      TextSpan(
                        text: _isSignUp
                            ? 'لديك حساب بالفعل؟ '
                            : 'ليس لديك حساب؟ ',
                      ),
                      TextSpan(
                        text: _isSignUp ? 'تسجيل الدخول' : 'إنشاء حساب',
                        style: const TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIGNED-IN PROFILE VIEW
// ─────────────────────────────────────────────
class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Header gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 40, bottom: 48, left: 20, right: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E0A3C), Color(0xFF2D1060)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0x4D7C3AED)),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Text('🎮', style: TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    app.userName ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    app.userEmail ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFC4B5FD),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      '⚡ Level ${app.level} — Mind Master',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1030),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF7C3AED).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      _StatItem(value: '42', label: 'تحديات'),
                      _vDivider(),
                      _StatItem(
                        value: '${app.streak}🔥',
                        label: 'Streak',
                        color: const Color(0xFFF59E0B),
                      ),
                      _vDivider(),
                      _StatItem(
                        value: app.score >= 1000
                            ? '${(app.score / 1000).toStringAsFixed(1)}K'
                            : '${app.score}',
                        label: 'XP',
                        color: const Color(0xFF7C3AED),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel(text: 'الشارات'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _Badge(label: '🧠 عقل نشيط', type: 'purple'),
                      _Badge(label: '🔥 7 أيام', type: 'gold'),
                      _Badge(label: '⚡ سريع', type: 'green'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// History
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SectionLabel(text: 'آخر التحديات'),
                  SizedBox(height: 4),
                  _HistoryItem(
                      icon: '🧠',
                      name: 'تحدي ذكاء',
                      date: 'اليوم · 2 من 3',
                      xp: '+80 XP'),
                  _HistoryItem(
                      icon: '🌍',
                      name: 'تعلم سريع',
                      date: 'أمس · 3 من 3',
                      xp: '+100 XP'),
                  _HistoryItem(
                      icon: '⚡',
                      name: 'تحدي سرعة',
                      date: 'أمس · 2 من 3',
                      xp: '+60 XP'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Sign out button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () =>
                    Provider.of<AppState>(context, listen: false).signOut(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1030),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '🚪 تسجيل الخروج',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 48,
        color: const Color(0xFF7C3AED).withOpacity(0.2),
      );
}

// ─────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────
class _InputLabel extends StatelessWidget {
  final String label;
  const _InputLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFFC4B5FD),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1030),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF7C3AED).withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF7C3AED), size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF9CA3AF),
        letterSpacing: 1.2,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatItem({
    required this.value,
    required this.label,
    this.color = const Color(0xFFF5F3FF),
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final String type;
  const _Badge({required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    Color bg, textColor, borderColor;
    switch (type) {
      case 'gold':
        bg = const Color(0xFFF59E0B).withOpacity(0.2);
        textColor = const Color(0xFFF59E0B);
        borderColor = const Color(0xFFF59E0B).withOpacity(0.3);
        break;
      case 'green':
        bg = const Color(0xFF10B981).withOpacity(0.2);
        textColor = const Color(0xFF6EE7B7);
        borderColor = const Color(0xFF10B981).withOpacity(0.3);
        break;
      default:
        bg = const Color(0xFF7C3AED).withOpacity(0.2);
        textColor = const Color(0xFFC4B5FD);
        borderColor = const Color(0xFF7C3AED).withOpacity(0.3);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String icon;
  final String name;
  final String date;
  final String xp;
  const _HistoryItem({
    required this.icon,
    required this.name,
    required this.date,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1A7C3AED))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF241840),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF5F3FF),
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Text(
            xp,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
    );
  }
}