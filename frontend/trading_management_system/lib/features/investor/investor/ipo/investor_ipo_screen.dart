import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/animations.dart';

class InvestorIpoScreen extends StatefulWidget {
  const InvestorIpoScreen({
    super.key,
    this.onBack,
    this.onApply,
    this.onDestinationSelected,
  });

  final VoidCallback? onBack;
  final ValueChanged<String>? onApply;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<InvestorIpoScreen> createState() => _InvestorIpoScreenState();
}

class _InvestorIpoScreenState extends State<InvestorIpoScreen> {

  final List<String> statuses = [
    'Open',
    'Upcoming',
    'Closed',
    'Completed',
    'Cancelled',
  ];

  String selectedStatus = 'Open';
  int selectedNavigation = 4;

  // Demo IPO data. Replace this with Django API data later.
  final List<_IpoData> ipoList = [
    _IpoData(
      name: 'Sample Bank IPO',
      symbol: 'ABCD',
      status: 'Open',
      price: 100,
      minimumUnits: 10,
      maximumUnits: 100,
      openDate: '12 Oct',
      closeDate: '16 Oct',
    ),
    _IpoData(
      name: 'Sample Hydropower IPO',
      symbol: 'EFGH',
      status: 'Upcoming',
      price: 100,
      minimumUnits: 10,
      maximumUnits: 100,
      openDate: '25 Oct',
      closeDate: '29 Oct',
    ),
  ];

  List<_IpoData> get filteredIpos {
    return ipoList.where((ipo) => ipo.status == selectedStatus).toList();
  }

  void selectStatus(String status) {
    setState(() {
      selectedStatus = status;
    });
  }

  void applyForIpo(_IpoData ipo) {
    if (widget.onApply != null) {
      widget.onApply!(ipo.symbol);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Apply for ${ipo.name} - next step coming soon.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surface,
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed:
                  widget.onBack ??
                  () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text,
                size: 29,
              ),
              tooltip: 'Back',
            ),
            const SizedBox(width: 2),
            const Text(
              'IPO',
              style: TextStyle(
                color: AppColors.text,
                fontFamily: AppFonts.serif,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 34),
          child: Text(
            'Public offerings',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget buildStatusFilters() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: statuses.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = selectedStatus == status;

          return GestureDetector(
            onTap: () => selectStatus(status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brass : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: isSelected ? AppColors.brass : AppColors.border),
              ),
              child: Center(
                child: Text(
                  status,
                  style: TextStyle(
                    color: isSelected ? AppColors.deep : AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildStatusBadge(String status) {
    Color badgeColor;

    switch (status) {
      case 'Open':
        badgeColor = AppColors.gain;
        break;
      case 'Upcoming':
        badgeColor = AppColors.brass;
        break;
      case 'Closed':
        badgeColor = AppColors.warning;
        break;
      case 'Completed':
        badgeColor = AppColors.gain;
        break;
      case 'Cancelled':
        badgeColor = AppColors.loss;
        break;
      default:
        badgeColor = AppColors.muted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: badgeColor),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildIpoCard(_IpoData ipo, int index) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('${selectedStatus}_${ipo.symbol}'),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company name and IPO status.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    ipo.name,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                buildStatusBadge(ipo.status),
              ],
            ),

            const SizedBox(height: 2),

            Text(
              ipo.symbol,
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),

            const SizedBox(height: 14),

            // IPO price and applicant units.
            Row(
              children: [
                Expanded(
                  child: _IpoDetail(
                    label: 'Price per unit',
                    value: 'Rs. ${ipo.price.toStringAsFixed(2)}',
                  ),
                ),
                Expanded(
                  child: _IpoDetail(
                    label: 'Units per applicant',
                    value: '${ipo.minimumUnits} to ${ipo.maximumUnits}',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Opens ${ipo.openDate} · Closes ${ipo.closeDate}',
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),

            if (ipo.status == 'Open') ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => applyForIpo(ipo),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brass,
                    foregroundColor: AppColors.deep,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 42,
            color: AppColors.muted.withOpacity(0.7),
          ),
          const SizedBox(height: 14),
          Text(
            'No $selectedStatus IPOs',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'There are currently no offerings in this category.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigation() {
    final items = [
      (label: 'Home', icon: Icons.home_outlined),
      (label: 'Portfolio', icon: Icons.pie_chart_outline_rounded),
      (label: 'Market', icon: Icons.show_chart_rounded),
      (label: 'Trade', icon: Icons.swap_vert_rounded),
      (label: 'More', icon: Icons.more_horiz_rounded),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final isSelected = selectedNavigation == index;
          final color = isSelected ? AppColors.brass : AppColors.muted;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedNavigation = index;
                });
                widget.onDestinationSelected?.call(index);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 30,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: AppColors.brass,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: isSelected ? 1.08 : 1,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(items[index].icon, color: color, size: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].label,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth >= 700
                      ? 32.0
                      : 24.0;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildHeader().fadeUp(0),
                            const SizedBox(height: 14),
                            buildStatusFilters().fadeUp(1),
                            const SizedBox(height: 10),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: filteredIpos.isEmpty
                                  ? buildEmptyState()
                                  : Column(
                                      key: ValueKey(selectedStatus),
                                      children: [
                                        for (
                                          int i = 0;
                                          i < filteredIpos.length;
                                          i++
                                        ) ...[
                                          if (i > 0) const SizedBox(height: 10),
                                          buildIpoCard(filteredIpos[i], i),
                                        ],
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            buildBottomNavigation(),
          ],
        ),
      ),
    );
  }
}

// IPO data model used by the screen.
// Later, this can be replaced by data returned from Django.
class _IpoData {
  const _IpoData({
    required this.name,
    required this.symbol,
    required this.status,
    required this.price,
    required this.minimumUnits,
    required this.maximumUnits,
    required this.openDate,
    required this.closeDate,
  });

  final String name;
  final String symbol;
  final String status;
  final double price;
  final int minimumUnits;
  final int maximumUnits;
  final String openDate;
  final String closeDate;
}

// Reusable IPO detail display.
class _IpoDetail extends StatelessWidget {
  const _IpoDetail({
    required this.label,
    required this.value,
    this.textAlign = TextAlign.left,
  });

  final String label;
  final String value;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: textAlign,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: textAlign,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
