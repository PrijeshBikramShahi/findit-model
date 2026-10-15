import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar + username
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A0A0A),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('U',
                        style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('@username',
                    style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Linked via Instagram',
                    style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 13,
                        color: Colors.grey[500])),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Stats row
          const Row(
            children: [
              _StatBox(label: 'Searches', value: '3'),
              SizedBox(width: 12),
              _StatBox(label: 'Saved', value: '2'),
              SizedBox(width: 12),
              _StatBox(label: 'Purchases', value: '0'),
            ],
          ),

          const SizedBox(height: 32),

          // How it works
          const Text('How it works',
              style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          const _HowItWorksStep(
              number: '1', text: 'See something you like on Instagram'),
          const _HowItWorksStep(
              number: '2', text: 'Tag @findit.app in the comments'),
          const _HowItWorksStep(
              number: '3', text: 'Open the app — your matches are ready'),

          const SizedBox(height: 32),

          // Settings
          _SettingsTile(
              icon: Icons.alternate_email_rounded,
              label: 'Change Instagram username',
              onTap: () {}),
          _SettingsTile(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () {}),
          _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: () {}),
          _SettingsTile(
              icon: Icons.logout_rounded,
              label: 'Sign out',
              onTap: () {},
              danger: true),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 24,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 11,
                    color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final String number;
  final String text;
  const _HowItWorksStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
                color: Color(0xFFD4A853), shape: BoxShape.circle),
            child: Center(
                child: Text(number,
                    style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0A0A0A)))),
          ),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(fontFamily: 'DM Sans', fontSize: 14)),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  const _SettingsTile(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.red : const Color(0xFF0A0A0A);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color, size: 20),
      title: Text(label,
          style: TextStyle(fontFamily: 'DM Sans', fontSize: 15, color: color)),
      trailing: danger
          ? null
          : const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }
}
