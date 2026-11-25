import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class InvestorIpoApplyScreen extends StatefulWidget {
  const InvestorIpoApplyScreen({
    super.key,
    this.companyName = 'Sample Bank IPO',
    this.symbol = 'ABCD',
    this.pricePerUnit = 100,
    this.minimumUnits = 10,
    this.maximumUnits = 100,
    this.closingDate = '16 Oct',
    this.onBack,
    this.onSubmit,
    this.onDestinationSelected,
  });

  final String companyName;
  final String symbol;
  final double pricePerUnit;
  final int minimumUnits;
  final int maximumUnits;
  final String closingDate;

  final VoidCallback? onBack;
  final ValueChanged<int>? onSubmit;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<InvestorIpoApplyScreen> createState() => _InvestorIpoApplyScreenState();
}

class _InvestorIpoApplyScreenState extends State<InvestorIpoApplyScreen> {

  late int units;
  int selectedNavigation = 4;

  @override
  void initState() {
    super.initState();
    units = widget.minimumUnits;
  }

  double get totalAmount => units * widget.pricePerUnit;

  String formatAmount(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final number = parts[0];
    final result = StringBuffer();

    for (int i = 0; i < number.length; i++) {
      if (i > 0 && (number.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(number[i]);
    }

    return 'Rs. ${result.toString()}.${parts[1]}';
  }

  void decreaseUnits() {
    if (units > widget.minimumUnits) {
      setState(() {
        units--;
      });
    }
  }

  void increaseUnits() {
    if (units < widget.maximumUnits) {
      setState(() {
        units++;
      });
    }
  }

  void submitApplication() {
    if (units < widget.minimumUnits || units > widget.maximumUnits) {
      return;
    }

    if (widget.onSubmit != null) {
      widget.onSubmit!(units);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application prepared for $units units.'),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
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
            const Expanded(
              child: Text(
                'Apply for IPO',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 34),
          child: Text(
            'Sample Bank IPO · ABCD',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget buildInformationRow({
    required String label,
    required String value,
    bool showBorder = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: showBorder
            ? const Border(bottom: BorderSide(color: AppColors.border))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIpoInformationCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          buildInformationRow(
            label: 'Price per unit',
            value: formatAmount(widget.pricePerUnit),
          ),
          buildInformationRow(
            label: 'Minimum units',
            value: widget.minimumUnits.toString(),
          ),
          buildInformationRow(
            label: 'Maximum units',
            value: widget.maximumUnits.toString(),
          ),
          buildInformationRow(
            label: 'Closes',
            value: widget.closingDate,
            showBorder: false,
          ),
        ],
      ),
    );
  }

  Widget buildUnitButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              icon,
              color: enabled ? AppColors.text : AppColors.muted.withOpacity(0.4),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Units to apply for',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            buildUnitButton(
              icon: Icons.remove,
              onPressed: decreaseUnits,
              enabled: units > widget.minimumUnits,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.brass),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      units.toString(),
                      key: ValueKey(units),
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            buildUnitButton(
              icon: Icons.add,
              onPressed: increaseUnits,
              enabled: units < widget.maximumUnits,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Enter between ${widget.minimumUnits} and '
          '${widget.maximumUnits} units.',
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ],
    );
  }

  Widget buildTotalAmount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total amount',
          style: TextStyle(color: AppColors.muted, fontSize: 14),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            formatAmount(totalAmount),
            key: ValueKey(totalAmount),
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: submitApplication,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brass,
          foregroundColor: AppColors.deep,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Submit application',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
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
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildHeader(),
                            buildIpoInformationCard(),
                            const SizedBox(height: 22),
                            buildUnitSelector(),
                            const SizedBox(height: 20),
                            buildTotalAmount(),
                            const SizedBox(height: 22),
                            buildSubmitButton(),
                            const SizedBox(height: 12),
                            const Text(
                              'You can change your application '
                              'while it is pending.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.muted, fontSize: 12),
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
