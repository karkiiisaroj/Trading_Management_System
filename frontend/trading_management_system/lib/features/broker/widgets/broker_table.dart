import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

import 'broker_widgets.dart';

/// One table column. [flex] sets the share of the row, [minWidth] is used to
/// decide when the table must scroll sideways on a narrow screen.
class BrokerColumn<T> {
  const BrokerColumn({
    required this.label,
    required this.cell,
    this.flex = 1,
    this.minWidth = 90,
  });

  /// Plain text column.
  factory BrokerColumn.text(
    String label,
    String Function(T item) value, {
    int flex = 1,
    double minWidth = 90,
    Color? color,
  }) {
    return BrokerColumn<T>(
      label: label,
      flex: flex,
      minWidth: minWidth,
      cell: (item) => Text(
        value(item),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.body.copyWith(fontSize: 14, color: color),
      ),
    );
  }

  final String label;
  final Widget Function(T item) cell;
  final int flex;
  final double minWidth;
}

/// Card with a header row and one row per item. Scrolls sideways when the
/// screen is narrower than the columns need.
class BrokerDataTable<T> extends StatelessWidget {
  const BrokerDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.title,
    this.trailing,
    this.onRowTap,
    this.footnote,
  });

  final List<BrokerColumn<T>> columns;
  final List<T> rows;

  /// Heading inside the card, e.g. "Recent orders".
  final String? title;
  final Widget? trailing;
  final ValueChanged<T>? onRowTap;
  final String? footnote;

  static const double _hPad = 20;

  @override
  Widget build(BuildContext context) {
    final minWidth =
        columns.fold<double>(0, (sum, c) => sum + c.minWidth) + _hPad * 2;

    return BrokerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(_hPad, 18, _hPad, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: AppTypography.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          LayoutBuilder(
            builder: (context, box) {
              final table = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _headerRow(),
                  for (final item in rows) _dataRow(item),
                ],
              );
              if (box.maxWidth >= minWidth) return table;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(width: minWidth, child: table),
              );
            },
          ),
          if (footnote != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: _hPad,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Text(footnote!, style: AppTypography.caption),
            ),
        ],
      ),
    );
  }

  Widget _headerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _hPad, vertical: 12),
      child: Row(
        children: [
          for (final c in columns)
            Expanded(
              flex: c.flex,
              child: Text(
                c.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.label.copyWith(fontSize: 12.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _dataRow(T item) {
    final row = Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: _hPad, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (final c in columns)
            Expanded(
              flex: c.flex,
              child: Align(
                alignment: Alignment.centerLeft,
                child: c.cell(item),
              ),
            ),
        ],
      ),
    );
    if (onRowTap == null) return row;
    return InkWell(onTap: () => onRowTap!(item), child: row);
  }
}

/// Skeleton shaped like a table, shown while a list loads.
class BrokerTableSkeleton extends StatelessWidget {
  const BrokerTableSkeleton({
    super.key,
    required this.labels,
    this.message = 'Loading\u2026',
    this.rows = 5,
  });

  final List<String> labels;
  final String message;
  final int rows;

  @override
  Widget build(BuildContext context) {
    return BrokerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                for (final l in labels)
                  Expanded(
                    child: Text(
                      l,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(fontSize: 12.5),
                    ),
                  ),
              ],
            ),
          ),
          BrokerPulse(
            child: Column(
              children: [
                for (var i = 0; i < rows; i++)
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        for (var j = 0; j < labels.length; j++)
                          const Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: BrokerSkeletonBar(width: 56),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Center(child: Text(message, style: AppTypography.caption)),
          ),
        ],
      ),
    );
  }
}

/// Search box + filter chip above a table.
class BrokerToolbar extends StatelessWidget {
  const BrokerToolbar({
    super.key,
    required this.controller,
    required this.searchHint,
    required this.onSearchChanged,
    this.onSearchSubmitted,
    this.filterLabel,
    this.filterValue,
    this.filterOptions = const [],
    this.onFilterSelected,
  });

  final TextEditingController controller;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;

  /// e.g. `Status`. Null hides the filter chip.
  final String? filterLabel;

  /// Currently shown value, e.g. `All`.
  final String? filterValue;
  final List<String> filterOptions;
  final ValueChanged<String>? onFilterSelected;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              textInputAction: TextInputAction.search,
              style: AppTypography.input,
              cursorColor: AppColors.brass,
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: AppTypography.input.copyWith(
                  color: AppColors.muted.withValues(alpha: .75),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.muted,
                ),
                filled: true,
                fillColor: AppColors.surface,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: _border(AppColors.border),
                enabledBorder: _border(AppColors.border),
                focusedBorder: _border(AppColors.brass),
              ),
            ),
          ),
        ),
        if (filterLabel != null) ...[
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            tooltip: 'Filter by ${filterLabel!.toLowerCase()}',
            color: AppColors.deep,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              side: const BorderSide(color: AppColors.border),
            ),
            onSelected: onFilterSelected,
            itemBuilder: (context) => [
              for (final o in filterOptions)
                PopupMenuItem<String>(
                  value: o,
                  child: Text(
                    o,
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      color: o == filterValue
                          ? AppColors.brass
                          : AppColors.text,
                    ),
                  ),
                ),
            ],
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${filterLabel!}: ${filterValue ?? 'All'}',
                    style: AppTypography.body.copyWith(fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.expand_more_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A searchable, filterable table that loads its own data and shows every
/// state in the design: loading, error, empty, no match.
///
/// Call [BrokerListPageState.reload] through a [GlobalKey] to refresh it
/// (e.g. after an order changes).
class BrokerListPage<T> extends StatefulWidget {
  const BrokerListPage({
    super.key,
    required this.load,
    required this.columns,
    required this.searchHint,
    required this.searchText,
    required this.loadingLabel,
    required this.errorTitle,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.noMatchTitle,
    required this.noMatchMessage,
    this.filterLabel,
    this.filterValueOf,
    this.includeAllOption = true,
    this.onRowTap,
    this.onSearchSubmitted,
    this.footnote,
  });

  final Future<List<T>> Function() load;
  final List<BrokerColumn<T>> columns;

  final String searchHint;

  /// Text the search box matches against (case-insensitive "contains").
  final String Function(T item) searchText;

  final String loadingLabel;
  final String errorTitle;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;
  final String noMatchTitle;
  final String noMatchMessage;

  /// Filter chip, e.g. `Status`. Options come from the loaded data through
  /// [filterValueOf], in order of first appearance.
  final String? filterLabel;
  final String Function(T item)? filterValueOf;

  /// When false the first option is selected and there is no "All".
  final bool includeAllOption;

  final ValueChanged<T>? onRowTap;

  /// Enter pressed in the search box. [query] is trimmed. [visible] is how
  /// many rows currently match.
  final void Function(String query, int visible)? onSearchSubmitted;

  final String? footnote;

  @override
  State<BrokerListPage<T>> createState() => BrokerListPageState<T>();
}

class BrokerListPageState<T> extends State<BrokerListPage<T>> {
  late Future<List<T>> _future = widget.load();
  final TextEditingController _search = TextEditingController();
  String _query = '';
  String? _filter;

  void reload() => setState(() => _future = widget.load());

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _search.clear();
    setState(() => _query = '');
  }

  List<String> _options(List<T> data) {
    final of = widget.filterValueOf;
    if (of == null) return const [];
    final seen = <String>[];
    for (final item in data) {
      final v = of(item);
      if (!seen.contains(v)) seen.add(v);
    }
    return [if (widget.includeAllOption) 'All', ...seen];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return BrokerPhaseSwitcher(phase: 'error', child: BrokerStatePanel(
            icon: Icons.error_outline_rounded,
            iconColor: AppColors.loss,
            title: widget.errorTitle,
            message: 'Check your connection and try again. If this keeps '
                'happening, contact your administrator.',
            actionLabel: 'Try again',
            onAction: reload,
          ));
        }

        final loading = snapshot.connectionState != ConnectionState.done;
        final data = snapshot.data ?? <T>[];

        if (!loading && data.isEmpty) {
          return BrokerPhaseSwitcher(phase: 'empty', child: BrokerStatePanel(
            icon: widget.emptyIcon,
            title: widget.emptyTitle,
            message: widget.emptyMessage,
          ));
        }

        final options = _options(data);
        final String? selected = widget.filterLabel == null
            ? null
            : (_filter != null && options.contains(_filter)
                ? _filter
                : (widget.includeAllOption
                    ? 'All'
                    : (options.isEmpty ? null : options.first)));

        final q = _query.trim().toLowerCase();
        final visible = data.where((item) {
          if (q.isNotEmpty &&
              !widget.searchText(item).toLowerCase().contains(q)) {
            return false;
          }
          if (selected != null && selected != 'All') {
            return widget.filterValueOf!(item) == selected;
          }
          return true;
        }).toList();

        return BrokerPhaseSwitcher(
          phase: 'list',
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BrokerToolbar(
              controller: _search,
              searchHint: widget.searchHint,
              onSearchChanged: (v) => setState(() => _query = v),
              onSearchSubmitted: widget.onSearchSubmitted == null
                  ? null
                  : (v) => widget.onSearchSubmitted!(v.trim(), visible.length),
              filterLabel: widget.filterLabel,
              filterValue: selected,
              filterOptions: options,
              onFilterSelected: (v) => setState(() => _filter = v),
            ),
            const SizedBox(height: 16),
            BrokerPhaseSwitcher(
              phase: loading
                  ? 'skeleton'
                  : (visible.isEmpty ? 'nomatch' : 'table'),
              child: loading
                  ? BrokerTableSkeleton(
                      labels: [for (final c in widget.columns) c.label],
                      message: widget.loadingLabel,
                    )
                  : visible.isEmpty
                      ? BrokerStatePanel(
                          icon: Icons.search_off_rounded,
                          title: widget.noMatchTitle,
                          message: widget.noMatchMessage,
                          actionLabel: q.isNotEmpty ? 'Clear search' : null,
                          onAction: _clearSearch,
                        )
                      : BrokerDataTable<T>(
                          columns: widget.columns,
                          rows: visible,
                          onRowTap: widget.onRowTap,
                          footnote: widget.footnote,
                        ),
            ),
          ],
        ),
        );
      },
    );
  }
}
