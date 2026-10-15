import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = TextEditingController();
  bool _submitted = false;

  void _continue() {
    if (_controller.text.trim().isEmpty) return;
    // TODO: save username to secure storage
    setState(() => _submitted = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // Logo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A853),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('F', style: TextStyle(fontFamily: 'Syne', fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF0A0A0A))),
                ),
              ),
              const SizedBox(height: 32),

              // Headline
              const Text(
                'See it.\nFind it.\nBuy it.',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFAF9F7),
                  height: 1.05,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Subtitle
              Text(
                'Tag @findit.app in any Instagram comment.\nWe\'ll find where to buy everything in the photo.',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 16,
                  color: const Color(0xFFFAF9F7).withOpacity(0.55),
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // Username input
              Text(
                'Your Instagram username',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFAF9F7).withOpacity(0.5),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                style: const TextStyle(fontFamily: 'DM Sans', color: Color(0xFFFAF9F7), fontSize: 16),
                decoration: InputDecoration(
                  hintText: '@username',
                  hintStyle: TextStyle(color: const Color(0xFFFAF9F7).withOpacity(0.25)),
                  prefixIcon: Icon(Icons.alternate_email_rounded, color: const Color(0xFFFAF9F7).withOpacity(0.4), size: 20),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.07),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD4A853), width: 1.5),
                  ),
                ),
                onSubmitted: (_) => _continue(),
              ),
              const SizedBox(height: 16),

              // CTA Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitted ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4A853),
                    foregroundColor: const Color(0xFF0A0A0A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    _submitted ? 'Getting ready...' : 'Get started',
                    style: const TextStyle(fontFamily: 'Syne', fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
