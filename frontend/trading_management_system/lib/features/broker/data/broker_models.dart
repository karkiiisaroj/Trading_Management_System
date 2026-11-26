/// Plain data classes for the broker area.
///
/// Everything here is already scoped to the signed-in broker by the
/// repository (BR-B05, BR-B09, BR-S05): no screen filters by broker itself and
/// no screen sends a broker id.
library;

/// Order lifecycle (BR-I28). [apiValue] is the value the Django API uses.
enum OrderStatus {
  pending('Pending', 'PENDING'),
  submitted('Submitted', 'SUBMITTED'),
  partial('Partial', 'PARTIALLY_EXECUTED'),
  executed('Executed', 'EXECUTED'),
  cancelled('Cancelled', 'CANCELLED'),
  rejected('Rejected', 'REJECTED');

  const OrderStatus(this.label, this.apiValue);

  final String label;
  final String apiValue;

  /// Statuses a broker may move this order to (BR-I29, BR-B15).
  /// Executed, cancelled and rejected orders are final.
  List<OrderStatus> get nextStatuses {
    switch (this) {
      case OrderStatus.pending:
        return const [
          OrderStatus.submitted,
          OrderStatus.partial,
          OrderStatus.executed,
          OrderStatus.cancelled,
          OrderStatus.rejected,
        ];
      case OrderStatus.submitted:
        return const [
          OrderStatus.partial,
          OrderStatus.executed,
          OrderStatus.cancelled,
          OrderStatus.rejected,
        ];
      case OrderStatus.partial:
        return const [OrderStatus.executed, OrderStatus.cancelled];
      case OrderStatus.executed:
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return const [];
    }
  }

  bool get isFinal => nextStatuses.isEmpty;

  /// Counts as an "open order" on dashboards and account lists.
  bool get isOpen => !isFinal;
}

class BrokerProfile {
  const BrokerProfile({
    required this.name,
    required this.brokerCode,
    required this.username,
    required this.email,
    required this.phone,
    required this.assignedInvestors,
  });

  final String name;
  final String brokerCode;
  final String username;
  final String email;
  final String phone;
  final int assignedInvestors;
}

class BrokerInvestor {
  const BrokerInvestor({
    required this.clientId,
    required this.name,
    required this.email,
    required this.phone,
    required this.accountNumber,
    required this.isActive,
    required this.assignedSince,
    this.holdingsCount = 0,
  });

  final String clientId;
  final String name;
  final String email;
  final String phone;
  final String accountNumber;
  final bool isActive;
  final String assignedSince;
  final int holdingsCount;

  BrokerInvestor withHoldings(int count) => BrokerInvestor(
        clientId: clientId,
        name: name,
        email: email,
        phone: phone,
        accountNumber: accountNumber,
        isActive: isActive,
        assignedSince: assignedSince,
        holdingsCount: count,
      );
}

class BrokerAccount {
  const BrokerAccount({
    required this.accountNumber,
    required this.investorName,
    required this.clientId,
    required this.openOrders,
    required this.isActive,
  });

  final String accountNumber;
  final String investorName;
  final String clientId;
  final int openOrders;
  final bool isActive;
}

class BrokerHolding {
  const BrokerHolding({
    required this.symbol,
    required this.quantity,
    required this.averageCost,
  });

  final String symbol;
  final int quantity;
  final double averageCost;
}

class InvestorDetails {
  const InvestorDetails({
    required this.investor,
    required this.holdings,
    required this.recentOrders,
    required this.portfolioValue,
    required this.openOrders,
  });

  final BrokerInvestor investor;
  final List<BrokerHolding> holdings;
  final List<BrokerOrder> recentOrders;
  final double portfolioValue;
  final int openOrders;
}

class BrokerOrder {
  const BrokerOrder({
    required this.orderNumber,
    required this.clientId,
    required this.symbol,
    required this.action,
    required this.quantity,
    required this.price,
    required this.status,
    required this.date,
  });

  /// Without the leading '#', e.g. `1042`.
  final String orderNumber;
  final String clientId;
  final String symbol;

  /// `Buy` or `Sell` (BR-I20).
  final String action;
  final int quantity;
  final double price;
  final OrderStatus status;
  final String date;

  bool get isBuy => action.toLowerCase() == 'buy';

  BrokerOrder copyWith({OrderStatus? status}) => BrokerOrder(
        orderNumber: orderNumber,
        clientId: clientId,
        symbol: symbol,
        action: action,
        quantity: quantity,
        price: price,
        status: status ?? this.status,
        date: date,
      );
}

class BrokerTrade {
  const BrokerTrade({
    required this.tradeNumber,
    required this.orderNumber,
    required this.clientId,
    required this.symbol,
    required this.quantity,
    required this.price,
    required this.status,
    required this.date,
  });

  /// e.g. `T-501`.
  final String tradeNumber;
  final String orderNumber;
  final String clientId;
  final String symbol;

  /// Quantity actually executed (BR-I32), possibly less than the order's.
  final int quantity;

  /// Actual execution price (BR-I33).
  final double price;
  final OrderStatus status;
  final String date;
}

class BrokerTransaction {
  const BrokerTransaction({
    required this.transactionNumber,
    required this.tradeNumber,
    required this.clientId,
    required this.symbol,
    required this.isBuy,
    required this.amount,
    required this.isCompleted,
    required this.date,
  });

  /// e.g. `T2031`.
  final String transactionNumber;
  final String tradeNumber;
  final String clientId;
  final String symbol;

  /// Matches the underlying order's BUY / SELL (BR-I35).
  final bool isBuy;

  /// Signed: negative for a buy, positive for a sell.
  final double amount;
  final bool isCompleted;
  final String date;

  String get typeLabel => isBuy ? 'Buy' : 'Sell';
  String get statusLabel => isCompleted ? 'Completed' : 'Pending';
}

class BrokerSecurity {
  const BrokerSecurity({
    required this.symbol,
    required this.company,
    required this.type,
    required this.isin,
    required this.lastClose,
    required this.isActive,
  });

  final String symbol;
  final String company;
  final String type;
  final String isin;
  final double lastClose;
  final bool isActive;
}

/// One historical record: security + trading date is unique (BR-I16).
class MarketRow {
  const MarketRow({
    required this.symbol,
    required this.date,
    required this.tradingDate,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  final String symbol;

  /// Short form for the table, e.g. `08 Oct`.
  final String date;

  /// Full form used by the date filter, e.g. `08 Oct 2026`.
  final String tradingDate;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;
}

/// BR-I48.
enum NotificationKind { order, trade, ipo, transaction, system }

class BrokerNotification {
  const BrokerNotification({
    required this.kind,
    required this.title,
    required this.message,
    required this.time,
  });

  final NotificationKind kind;
  final String title;
  final String message;
  final String time;
}

class BrokerActivity {
  const BrokerActivity({
    required this.time,
    required this.action,
    required this.clientId,
    required this.details,
  });

  final String time;
  final String action;
  final String clientId;
  final String details;
}

class DashboardSummary {
  const DashboardSummary({
    required this.assignedInvestors,
    required this.tradingAccounts,
    required this.pendingOrders,
    required this.assignedSecurities,
    required this.recentOrders,
  });

  final int assignedInvestors;
  final int tradingAccounts;
  final int pendingOrders;
  final int assignedSecurities;
  final List<BrokerOrder> recentOrders;
}

// ---------------------------------------------------------------------------
// Errors the repository can raise. Screens turn them into the design's
// states (403, inactive broker, rejected update).
// ---------------------------------------------------------------------------

/// The investor / order is outside this broker's assignments (BR-B05, BR-B09).
class BrokerAccessDenied implements Exception {
  const BrokerAccessDenied();

  @override
  String toString() => 'BrokerAccessDenied';
}

/// The broker account is inactive (BR-07, BR-B04).
class BrokerInactive implements Exception {
  const BrokerInactive();

  @override
  String toString() => 'BrokerInactive';
}

/// A business rule refused the change. [message] is safe to show.
class BrokerRuleViolation implements Exception {
  const BrokerRuleViolation(this.message);

  final String message;

  @override
  String toString() => 'BrokerRuleViolation: $message';
}

// ---------------------------------------------------------------------------
// Formatting
// ---------------------------------------------------------------------------

abstract final class BrokerFormat {
  static String _group(String digits) => digits.replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ',',
      );

  /// `Rs. 1,245.00`
  static String rs(double value, {int decimals = 2}) {
    final fixed = value.abs().toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final whole = _group(parts.first);
    final text = parts.length > 1 ? '$whole.${parts[1]}' : whole;
    return 'Rs. $text';
  }

  /// `Rs. 1.25M`, `Rs. 12.4K`, otherwise [rs].
  static String rsCompact(double value) {
    final v = value.abs();
    if (v >= 1000000) return 'Rs. ${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 100000) return 'Rs. ${(v / 1000).toStringAsFixed(1)}K';
    return rs(v);
  }

  /// `+ Rs. 35,808.00` / `− Rs. 9,051.00`
  static String signedRs(double value) =>
      '${value < 0 ? '\u2212' : '+'} ${rs(value)}';

  /// `12,400`
  static String integer(int value) => _group(value.toString());

  /// Up to two initials: `Sample Investor 1` -> `SI`.
  static String initials(String name) {
    final parts = name
        .replaceAll(RegExp(r'[\[\]]'), '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final w = parts.first;
      return w.substring(0, w.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }
}
