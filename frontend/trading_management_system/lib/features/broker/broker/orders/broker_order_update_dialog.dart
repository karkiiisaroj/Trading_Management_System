import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

import '../../data/broker_models.dart';
import '../../data/broker_repository.dart';

/// "Update order #1042". Resolves to the updated order, or null if the
/// broker cancelled. Final orders (executed / cancelled / rejected) open
/// read-only (BR-I29).
Future<BrokerOrder?> showBrokerOrderUpdateDialog(
  BuildContext context, {
  required BrokerRepository repository,
  required BrokerOrder order,
}) {
  return showDialog<BrokerOrder>(
    context: context,
    barrierColor: AppColors.scrim,
    builder: (_) => _OrderUpdateDialog(repository: repository, order: order),
  );
}

class _OrderUpdateDialog extends StatefulWidget {
  const _OrderUpdateDialog({required this.repository, required this.order});

  final BrokerRepository repository;
  final BrokerOrder order;

  @override
  State<_OrderUpdateDialog> createState() => _OrderUpdateDialogState();
}

class _OrderUpdateDialogState extends State<_OrderUpdateDialog> {
  OrderStatus? _selected;
  bool _saving = false;
  String? _error;

  BrokerOrder get _order => widget.order;
  List<OrderStatus> get _allowed => _order.status.nextStatuses;
  bool get _readOnly => _allowed.isEmpty;

  Future<void> _save() async {
    final status = _selected;
    if (status == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final updated =
          await widget.repository.updateOrderStatus(_order.orderNumber, status);
      if (!mounted) return;
      Navigator.of(context).pop(updated);
    } on BrokerRuleViolation catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = e.message;
      });
    } on BrokerAccessDenied {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = "You don't have access to this order.";
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = "Couldn't save the status. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _readOnly
                    ? 'Order #${_order.orderNumber}'
                    : 'Update order #${_order.orderNumber}',
                style: AppTypography.heading,
              ),
              const SizedBox(height: 6),
              Text(
                '${_order.symbol} \u00b7 ${_order.action} \u00b7 '
                '${_order.quantity} units \u00b7 Client ${_order.clientId}',
                style: AppTypography.bodyMuted.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 20),
              Text(
                _readOnly ? 'Status' : 'New status',
                style: AppTypography.label,
              ),
              const SizedBox(height: 8),
              for (final s in OrderStatus.values) _option(s),
              if (_readOnly) ...[
                const SizedBox(height: 4),
                Text(
                  "This order is ${_order.status.label.toLowerCase()}, so its "
                  "status can't be changed.",
                  style: AppTypography.caption,
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                AarthaInlineError(_error!),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: AarthaButton(
                      label: _readOnly ? 'Close' : 'Cancel',
                      variant: AarthaButtonVariant.secondary,
                      onPressed:
                          _saving ? null : () => Navigator.of(context).pop(),
                    ),
                  ),
                  if (!_readOnly) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: AarthaButton(
                        label: 'Save status',
                        loading: _saving,
                        loadingLabel: 'Saving\u2026',
                        onPressed: _selected == null ? null : _save,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option(OrderStatus s) {
    final isCurrent = s == _order.status;
    final enabled = _allowed.contains(s) && !_saving;
    final selected = _selected == s;
    final marked = selected || (_readOnly && isCurrent);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Opacity(
        opacity: enabled || marked ? 1 : .45,
        child: Material(
          color: selected ? AppColors.deep : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            side: BorderSide(
              color: selected ? AppColors.brass : AppColors.border,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            onTap: enabled ? () => setState(() => _selected = s) : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    marked
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 20,
                    color: marked ? AppColors.brass : AppColors.muted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(s.label, style: AppTypography.body),
                  ),
                  if (isCurrent && !_readOnly)
                    Text('Current', style: AppTypography.caption),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
