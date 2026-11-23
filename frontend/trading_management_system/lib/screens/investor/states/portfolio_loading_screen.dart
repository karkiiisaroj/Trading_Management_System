import 'package:flutter/material.dart';

class PortfolioLoadingScreen extends StatefulWidget {
  const PortfolioLoadingScreen({super.key});

  @override
  State<PortfolioLoadingScreen> createState() => _PortfolioLoadingScreenState();
}

class _PortfolioLoadingScreenState extends State<PortfolioLoadingScreen>
    with TickerProviderStateMixin {
  static const String fontFamily = 'AARTHA';

  static const Color background = Color(0xFF18372B);
  static const Color sidebarColor = Color(0xFF12291F);
  static const Color cardColor = Color(0xFF1F4435);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color cream = Color(0xFFF4F1E9);
  static const Color muted = Color(0xFFB5C3B9);

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _skeleton({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseAnimation.value,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortfolioSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeleton(width: 90, height: 12),
              const SizedBox(height: 10),
              _skeleton(width: 140, height: 22, radius: 8),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _skeleton(width: 50, height: 12),
              const SizedBox(height: 10),
              _skeleton(width: 70, height: 18, radius: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHoldingSkeleton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeleton(width: 70, height: 14, radius: 8),
              const SizedBox(height: 8),
              _skeleton(width: 130, height: 11),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _skeleton(width: 80, height: 14, radius: 8),
              const SizedBox(height: 8),
              _skeleton(width: 60, height: 11),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      _BottomNavItem('Home', Icons.home_outlined),
      _BottomNavItem('Portfolio', Icons.pie_chart_outline),
      _BottomNavItem('Market', Icons.trending_up),
      _BottomNavItem('Trade', Icons.swap_vert),
      _BottomNavItem('More', Icons.more_horiz),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: sidebarColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: items.map((item) {
          final isActive = item.label == 'Portfolio';

          return Expanded(
            child: InkWell(
              onTap: () {
                // UI-only navigation placeholder.
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 22, color: isActive ? gold : muted),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isActive ? gold : muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Portfolio',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          color: cream,
                        ),
                      ),

                      const SizedBox(height: 2),

                      const Text(
                        'Loading your holdings',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 13,
                          color: muted,
                        ),
                      ),

                      _buildPortfolioSummary(),

                      const SizedBox(height: 22),

                      const Text(
                        'Loading your holdings…',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 12,
                          color: muted,
                        ),
                      ),

                      const SizedBox(height: 2),

                      ...List.generate(5, (index) => _buildHoldingSkeleton()),
                    ],
                  ),
                ),
              ),
            ),

            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final String label;
  final IconData icon;

  const _BottomNavItem(this.label, this.icon);
}
