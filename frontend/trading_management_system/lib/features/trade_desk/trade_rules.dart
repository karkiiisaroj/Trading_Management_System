/// Limits the trade desk enforces on every order request.
///
/// These are the server-side numbers. The Flutter screens may show them to
/// help the investor, but they never decide anything: the desk re-checks
/// every rule (BR-I25, BR-S06) no matter what the client sent.
class TradeLimits {
  const TradeLimits({
    this.maxQuantityPerOrder = 10000,
    this.maxOrderValue = 2500000,
    this.priceBandPercent = 10,
    this.maxOrdersPerWindow = 5,
    this.window = const Duration(minutes: 1),
    this.maxOpenOrders = 20,
    this.maxPinAttempts = 3,
    this.pinLockout = const Duration(minutes: 5),
    this.authorizationTtl = const Duration(minutes: 2),
  });

  /// Largest quantity in one order.
  final int maxQuantityPerOrder;

  /// Largest `quantity x price` in one order, in rupees.
  final double maxOrderValue;

  /// How far (in %) an order price may sit from the last historical close.
  final double priceBandPercent;

  /// At most this many orders per [window] for one investor (anti-flood).
  final int maxOrdersPerWindow;
  final Duration window;

  /// Open (pending / submitted / partial) orders one investor may hold.
  final int maxOpenOrders;

  /// Wrong PIN attempts before the investor is locked out for [pinLockout].
  final int maxPinAttempts;
  final Duration pinLockout;

  /// How long a PIN approval stays valid for the one order it was given for.
  final Duration authorizationTtl;
}

/// Why the desk refused an order request. Each one maps to a business rule.
enum TradeRefusal {
  /// No valid, unexpired, unused approval for this exact order.
  authorizationRequired(
    'Your approval for this order has expired. Please confirm it again.',
    recordsOrder: false,
  ),

  /// The account is not one of this investor's (BR-08, BR-09).
  accountNotOwned(
    "That trading account isn't available to you.",
    recordsOrder: false,
  ),

  /// Too many orders too quickly.
  rateLimited(
    "You're sending orders too quickly. Wait a moment and try again.",
    recordsOrder: false,
  ),

  /// BR-B12.
  accountInactive(
    'This trading account is inactive. Contact your broker to reactivate it.',
  ),

  /// BR-07.
  securityUnavailable(
    "This security isn't available to trade right now.",
  ),

  /// BR-B19, BR-B22.
  securityNotCovered(
    "Your broker doesn't trade this security for this account.",
  ),

  /// BR-I21.
  invalidQuantity('Quantity must be a whole number greater than 0.'),

  /// BR-I22.
  invalidPrice('Price must be greater than 0.'),

  quantityLimit('This is more than the largest quantity allowed in one order.'),

  valueLimit('This order is above the largest value allowed in one order.'),

  priceOutsideBand(
    'The price is too far from the last close. Check it and try again.',
  ),

  insufficientHoldings(
    "You can't sell more than you hold, including units already in open "
    'sell orders.',
  ),

  tooManyOpenOrders(
    'You have too many open orders. Wait for some to complete or cancel them.',
  );

  const TradeRefusal(this.message, {this.recordsOrder = true});

  /// Investor-facing reason.
  final String message;

  /// Business-validation failures are kept as a Rejected order for the audit
  /// trail (BR-I25). Gate failures (approval, ownership, flooding) are not
  /// valid orders, so nothing is recorded.
  final bool recordsOrder;
}
