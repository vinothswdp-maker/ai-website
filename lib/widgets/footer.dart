import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const _columns = [
    {
      'title': 'Platform',
      'links': ['AI Agents', 'Voice API', 'SMS API', 'WhatsApp API', 'Pricing'],
    },
    {
      'title': 'Communications',
      'links': ['Voice', 'SMS', 'WhatsApp', 'Chat', 'Email'],
    },
    {
      'title': 'Developers',
      'links': ['API Reference', 'Documentation', 'SDKs', 'Status Page', 'Changelog'],
    },
    {
      'title': 'Company',
      'links': ['About Us', 'Blog', 'Careers', 'Security', 'Support'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      color: AppColors.dark,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 48 : 72,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 240, child: _buildBrand()),
                        const SizedBox(width: 48),
                        ..._columns.map(
                          (col) => Expanded(child: _FooterColumn(column: col)),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrand(),
                        const SizedBox(height: 48),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 2 : 4,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 32,
                            childAspectRatio: isMobile ? 1.2 : 1.0,
                          ),
                          itemCount: _columns.length,
                          itemBuilder: (context, index) =>
                              _FooterColumn(column: _columns[index]),
                        ),
                      ],
                    ),
              const SizedBox(height: 64),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              const SizedBox(height: 28),
              _buildBottom(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Pulse',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'The cloud communications platform for builders.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        _buildSocialLinks(),
      ],
    );
  }

  Widget _buildSocialLinks() {
    final icons = [
      Icons.code,
      Icons.chat,
      Icons.play_circle,
      Icons.business,
    ];
    return Row(
      children: icons.map((icon) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _SocialIcon(icon: icon),
        );
      }).toList(),
    );
  }

  Widget _buildBottom(bool isMobile) {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCopyrightText(),
              const SizedBox(height: 12),
              _buildLegalLinks(),
            ],
          )
        : Row(
            children: [
              _buildCopyrightText(),
              const Spacer(),
              _buildLegalLinks(),
            ],
          );
  }

  Widget _buildCopyrightText() {
    return Text(
      '© 2024 Pulse Inc. All rights reserved.',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.35),
        fontSize: 13,
      ),
    );
  }

  Widget _buildLegalLinks() {
    return Wrap(
      spacing: 20,
      children: ['Privacy Policy', 'Terms of Service', 'Cookie Preferences']
          .map((item) => Text(
                item,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 13,
                ),
              ))
          .toList(),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final Map<String, dynamic> column;
  const _FooterColumn({required this.column});

  @override
  Widget build(BuildContext context) {
    final links = column['links'] as List<String>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          column['title'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => _FooterLink(label: link)),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  const _FooterLink({required this.label});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          widget.label,
          style: TextStyle(
            color: _hovered
                ? Colors.white
                : Colors.white.withValues(alpha: 0.45),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _hovered
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: _hovered ? 0.2 : 0.1),
          ),
        ),
        child: Icon(widget.icon, color: Colors.white, size: 18),
      ),
    );
  }
}
