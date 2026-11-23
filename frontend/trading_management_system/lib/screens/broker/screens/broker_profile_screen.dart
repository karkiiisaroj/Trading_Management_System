import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrokerProfileScreen extends StatelessWidget {
  const BrokerProfileScreen({super.key});

  static const Color bg = Color(0xFF18372B);
  static const Color sidebarBg = Color(0xFF12291F);
  static const Color cardBg = Color(0xFF1F4435);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color muted = Color(0xFFB5C3B9);
  static const Color cream = Color(0xFFF4F1E9);
  static const Color danger = Color(0xFFFF8A80);

  TextStyle get manrope => GoogleFonts.manrope(color: cream);

  TextStyle get cormorant =>
      GoogleFonts.cormorantGaramond(color: cream, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 860;

          return Row(
            children: [
              if (isDesktop) const BrokerSidebar(),

              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 20,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _header(),
                        const SizedBox(height: 28),
                        _profileCard(context),
                        const SizedBox(height: 14),
                        Text(
                          'Sample data',
                          style: manrope.copyWith(fontSize: 11, color: muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: cormorant.copyWith(fontSize: 34, height: 1.1),
            ),
            const SizedBox(height: 4),
            Text(
              'Your broker account',
              style: manrope.copyWith(fontSize: 14, color: muted),
            ),
          ],
        ),
        Row(
          children: [
            _headerCircle(
              const Icon(Icons.notifications_none, color: cream, size: 20),
            ),
            const SizedBox(width: 12),
            _headerCircle(
              Text(
                'BR',
                style: manrope.copyWith(
                  color: gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerCircle(Widget child) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cardBg,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _profileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 560),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _identity(),
          const SizedBox(height: 16),

          _detailRow('Username', '[username]'),
          _detailRow('Email', '[email]'),
          _detailRow('Phone', '[phone]'),
          _detailRow('Assigned investors', '24', last: true),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 380) {
                return Column(
                  children: [
                    _changePasswordButton(),
                    const SizedBox(height: 12),
                    _signOutButton(context),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: _changePasswordButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _signOutButton(context)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _identity() {
    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: sidebarBg,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
          alignment: Alignment.center,
          child: Text(
            'BR',
            style: cormorant.copyWith(fontSize: 36, color: gold),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('[Broker name]', style: cormorant.copyWith(fontSize: 28)),
              const SizedBox(height: 2),
              Text(
                'Broker code B001',
                style: manrope.copyWith(color: muted, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: manrope.copyWith(fontSize: 14, color: muted)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: manrope.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _changePasswordButton() {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: cream,
          side: const BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Change password',
          style: manrope.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _signOutButton(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: danger,
          side: const BorderSide(color: danger),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          'Sign out',
          style: manrope.copyWith(
            color: danger,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// BROKER SIDEBAR

class BrokerSidebar extends StatelessWidget {
  const BrokerSidebar({super.key});

  static const Color sidebarBg = Color(0xFF12291F);
  static const Color cardBg = Color(0xFF1F4435);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color muted = Color(0xFFB5C3B9);
  static const Color cream = Color(0xFFF4F1E9);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: sidebarBg,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _logo(),
          const SizedBox(height: 4),

          _navItem(Icons.home_outlined, 'Dashboard'),
          _navItem(Icons.people_outline, 'Investors'),
          _navItem(Icons.work_outline, 'Trading accounts'),
          _navItem(Icons.list, 'Orders'),
          _navItem(Icons.sync, 'Trades'),
          _navItem(Icons.trending_up, 'Market'),
          _navItem(Icons.layers_outlined, 'Securities'),
          _navItem(Icons.notifications_none, 'Notifications'),
          _navItem(Icons.person_outline, 'Profile', active: true),

          const Spacer(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 14, left: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[Broker name]',
                  style: GoogleFonts.manrope(
                    color: cream,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Broker',
                  style: GoogleFonts.manrope(color: muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _logo() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 24),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF18372B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Image.asset('assets/aartha_logo.png', fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Text(
            'AARTHA',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: cream,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String title, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: active ? cardBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: Icon(icon, size: 20, color: active ? gold : muted),
        title: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: active ? gold : muted,
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
