import 'package:flutter/material.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../trade_desk/trade_desk.dart';

/// Asks the investor for their trade PIN before an order request is sent.
///
/// The sheet never decides anything. It hands the PIN to [verify] (the desk,
/// later the Django API) and only returns the single-use approval it gets
/// back. A wrong PIN, a lockout and the attempt count all come from the desk.
///
/// Returns the approval, or null when the investor closes the sheet.
Future<String?> showTradeVerifySheet(
  BuildContext context, {
  required String summary,
  required PinResult Function(String pin) verify,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _VerifySheet(summary: summary, verify: verify),
  );
}

class _VerifySheet extends StatefulWidget {
  const _VerifySheet({required this.summary, required this.verify});

  final String summary;
  final PinResult Function(String pin) verify;

  @override
  State<_VerifySheet> createState() => _VerifySheetState();
}

class _VerifySheetState extends State<_VerifySheet> {
  final TextEditingController _pin = TextEditingController();
  String? _error;
  DateTime? _lockedUntil;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  void _submit() {
    final entered = _pin.text.trim();
    if (entered.length < 4) {
      setState(() => _error = 'Enter your 4-digit trade PIN.');
      return;
    }
    final result = widget.verify(entered);
    if (result.approved) {
      Navigator.of(context).pop(result.authorization);
      return;
    }
    _pin.clear();
    setState(() {
      if (result.isLocked) {
        _lockedUntil = result.lockedUntil;
        final mins = result.lockedUntil!
            .difference(DateTime.now())
            .inMinutes
            .clamp(1, 60);
        _error = 'Too many wrong attempts. Try again in about $mins '
            '${mins == 1 ? 'minute' : 'minutes'}.';
      } else {
        final left = result.attemptsLeft;
        _error = 'Wrong PIN. $left ${left == 1 ? 'attempt' : 'attempts'} left.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locked = _lockedUntil != null && DateTime.now().isBefore(_lockedUntil!);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline_rounded, color: AppColors.brass),
              const SizedBox(width: 10),
              Text('Confirm with your PIN', style: AppTypography.heading.copyWith(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.summary, style: AppTypography.bodyMuted),
          const SizedBox(height: 16),
          TextField(
            controller: _pin,
            enabled: !locked,
            autofocus: true,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 22,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••',
              errorText: _error,
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: locked ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brass,
                foregroundColor: AppColors.deep,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Send order request',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
