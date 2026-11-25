import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../auth/auth_session.dart';

import 'broker/accounts/broker_accounts_screen.dart';
import 'broker/activity/broker_activity_screen.dart';
import 'broker/dashboard/broker_dashboard_screen.dart';
import 'broker/investors/broker_investor_details_screen.dart';
import 'broker/investors/broker_investors_screen.dart';
import 'broker/market/broker_market_screen.dart';
import 'broker/notifications/broker_notifications_screen.dart';
import 'broker/orders/broker_orders_screen.dart';
import 'broker/profile/broker_profile_screen.dart';
import 'broker/securities/broker_securities_screen.dart';
import 'broker/trades/broker_trades_screen.dart';
import 'broker/transactions/broker_transactions_screen.dart';
import 'data/broker_models.dart';
import 'data/broker_repository.dart';
import 'state/broker_access_screen.dart';
import 'state/broker_inactive_screen.dart';
import 'widgets/broker_shell.dart';
import 'widgets/broker_widgets.dart';

/// The whole broker journey, in one place.
///
/// ```
/// Sidebar (replaces the page)
///   Dashboard ─► View all ─► Orders · Activity history
///   Investors ─► Investor details ─► (not assigned) No-access state  (BR-B09)
///   Trading accounts ─► Investor details
///   Orders ─► Update status (open orders only)        (BR-I29, BR-B15)
///   Trades · Transactions · Market (historical) · Securities
///   Notifications (read-only) · Profile ─► Sign out
/// Inactive broker ─► Inactive state on every page      (BR-07, BR-B04)
/// ```
///
/// The broker comes from the authenticated [session] (BR-08): the repository
/// is created from [AuthSession.brokerCode] and no screen passes a broker id.
/// Pass your own [repository] to use the real API.
class BrokerFlow extends StatefulWidget {
  const BrokerFlow({
    super.key,
    required this.session,
    required this.onSignOut,
    this.repository,
  });

  final AuthSession session;
  final VoidCallback onSignOut;
  final BrokerRepository? repository;

  @override
  State<BrokerFlow> createState() => _BrokerFlowState();
}

class _BrokerFlowState extends State<BrokerFlow> {
  late final BrokerRepository _repo = widget.repository ??
      DemoBrokerRepository(
        brokerCode: widget.session.brokerCode ?? '',
        displayName: widget.session.displayName,
        username: widget.session.username,
      );

  /// The profile call doubles as the access check (inactive broker).
  late Future<BrokerProfile> _gate = _repo.profile();

  BrokerSection _section = BrokerSection.dashboard;
  String? _clientId; // investor details open
  bool _activity = false; // activity history open
  bool _denied = false; // investor details answered 403

  String get _name => widget.session.displayName;

  bool get _atRoot =>
      _section == BrokerSection.dashboard && _clientId == null && !_activity;

  void _go(BrokerSection section) => setState(() {
        _section = section;
        _clientId = null;
        _activity = false;
        _denied = false;
      });

  void _openInvestor(String clientId) => setState(() {
        _section = BrokerSection.investors;
        _clientId = clientId;
        _activity = false;
        _denied = false;
      });

  void _openActivity() => setState(() {
        _section = BrokerSection.dashboard;
        _clientId = null;
        _activity = true;
        _denied = false;
      });

  /// System back: one level up, then to the dashboard.
  void _back() {
    if (_activity) return _go(BrokerSection.dashboard);
    if (_clientId != null || _denied) return _go(_section);
    _go(BrokerSection.dashboard);
  }

  void _onAccessDenied() {
    if (_denied) return;
    setState(() => _denied = true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BrokerProfile>(
      future: _gate,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          if (snapshot.error is BrokerInactive) return _inactive();
          return _gateError();
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.brass),
            ),
          );
        }
        return PopScope(
          canPop: _atRoot,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _back();
          },
          child: _main(),
        );
      },
    );
  }

  Widget _inactive() => BrokerShell(
        selected: BrokerSection.dashboard,
        onNavigate: (_) {},
        brokerName: _name,
        title: 'Dashboard',
        subtitle: 'Overview of your investors and orders',
        child: BrokerInactiveScreen(onSignOut: widget.onSignOut),
      );

  Widget _gateError() => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: BrokerStatePanel(
                  icon: Icons.error_outline_rounded,
                  iconColor: AppColors.loss,
                  title: "Couldn't load your account",
                  message: 'Check your connection and try again. If this '
                      'keeps happening, contact your administrator.',
                  actionLabel: 'Try again',
                  onAction: () => setState(() => _gate = _repo.profile()),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _main() {
    final page = _page();
    return BrokerShell(
      selected: _section,
      onNavigate: _go,
      brokerName: _name,
      title: page.title,
      subtitle: page.subtitle,
      leading: page.back,
      // A new key per page replays the entrance animation.
      child: FadeSlideIn(
        key: ValueKey('$_section|$_clientId|$_activity|$_denied'),
        duration: const Duration(milliseconds: 350),
        offset: const Offset(0, 10),
        child: page.body,
      ),
    );
  }

  ({String title, String subtitle, Widget? back, Widget body}) _page() {
    if (_activity) {
      return (
        title: 'Activity history',
        subtitle: "Recent actions on your investors' accounts",
        back: BrokerBackLink(
          label: 'Dashboard',
          onTap: () => _go(BrokerSection.dashboard),
        ),
        body: BrokerActivityScreen(repository: _repo),
      );
    }

    if (_denied) {
      return (
        title: 'Investors',
        subtitle: 'Investors assigned to you',
        back: null,
        body: BrokerAccessScreen(
          onBackToInvestors: () => _go(BrokerSection.investors),
        ),
      );
    }

    final clientId = _clientId;
    if (clientId != null) {
      return (
        title: 'Investor details',
        subtitle: 'Assigned investor',
        back: BrokerBackLink(
          label: 'Investors',
          onTap: () => _go(BrokerSection.investors),
        ),
        body: BrokerInvestorDetailsScreen(
          repository: _repo,
          clientId: clientId,
          onAccessDenied: _onAccessDenied,
        ),
      );
    }

    switch (_section) {
      case BrokerSection.dashboard:
        return (
          title: 'Broker dashboard',
          subtitle: 'Overview of your assigned investors',
          back: null,
          body: BrokerDashboardScreen(
            repository: _repo,
            onViewOrders: () => _go(BrokerSection.orders),
            onViewActivity: _openActivity,
          ),
        );
      case BrokerSection.investors:
        return (
          title: 'Assigned investors',
          subtitle: 'You see only the investors assigned to you',
          back: null,
          body: BrokerInvestorsScreen(
            repository: _repo,
            onOpenInvestor: _openInvestor,
          ),
        );
      case BrokerSection.accounts:
        return (
          title: 'Trading accounts',
          subtitle: 'Accounts of your assigned investors',
          back: null,
          body: BrokerAccountsScreen(
            repository: _repo,
            onOpenInvestor: _openInvestor,
          ),
        );
      case BrokerSection.orders:
        return (
          title: 'Orders',
          subtitle: 'Monitor and manage orders from your investors',
          back: null,
          body: BrokerOrdersScreen(repository: _repo),
        );
      case BrokerSection.trades:
        return (
          title: 'Trades',
          subtitle: 'Executed trades of your investors',
          back: null,
          body: BrokerTradesScreen(repository: _repo),
        );
      case BrokerSection.transactions:
        return (
          title: 'Transactions',
          subtitle: 'Settlement records for trades from your investors',
          back: null,
          body: BrokerTransactionsScreen(repository: _repo),
        );
      case BrokerSection.market:
        return (
          title: 'Market',
          subtitle: 'Historical market data. Not live.',
          back: null,
          body: BrokerMarketScreen(repository: _repo),
        );
      case BrokerSection.securities:
        return (
          title: 'Securities',
          subtitle: 'Securities assigned to you',
          back: null,
          body: BrokerSecuritiesScreen(repository: _repo),
        );
      case BrokerSection.notifications:
        return (
          title: 'Notifications',
          subtitle: 'Updates about your assigned investors (read-only)',
          back: null,
          body: BrokerNotificationsScreen(repository: _repo),
        );
      case BrokerSection.profile:
        return (
          title: 'Profile',
          subtitle: 'Your broker account',
          back: null,
          body: BrokerProfileScreen(
            repository: _repo,
            onSignOut: widget.onSignOut,
          ),
        );
    }
  }
}
