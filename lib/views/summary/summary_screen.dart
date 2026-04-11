import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/summary_controller.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/l10n_ext.dart';
import '../../core/theme.dart';

class SummaryScreen extends StatefulWidget {
  final int userId;
  final int year;
  final int month;

  const SummaryScreen({
    super.key,
    required this.userId,
    required this.year,
    required this.month,
    this.showAppBar = true,
  });

  final bool showAppBar;

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _year = widget.year;
    _month = widget.month;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final ctrl = context.read<SummaryController>();
    ctrl.loadMonthly(widget.userId, _year, _month);
    ctrl.loadYearly(widget.userId, _year);
  }

  String _monthName(BuildContext context, int m) {
    final l = context.l10n;
    return [
      l.monthJan, l.monthFeb, l.monthMar, l.monthApr,
      l.monthMay, l.monthJun, l.monthJul, l.monthAug,
      l.monthSep, l.monthOct, l.monthNov, l.monthDec,
    ][m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<SummaryController>();
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(context.l10n.summaryTitle),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
              actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
            )
          : null,
      body: ctrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ctrl.error != null
              ? Center(child: Text(ctrl.error!, style: TextStyle(color: context.appDanger)))
              : RefreshIndicator(
                  onRefresh: () async => _load(),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              DropdownButton<int>(
                                value: _year,
                                isDense: true,
                                underline: const SizedBox(),
                                items: List.generate(10, (i) {
                                  final y = DateTime.now().year - i + 1;
                                  return DropdownMenuItem(value: y, child: Text('$y'));
                                }),
                                onChanged: (y) {
                                  setState(() => _year = y!);
                                  _load();
                                },
                              ),
                              const SizedBox(width: 8),
                              DropdownButton<int>(
                                value: _month,
                                isDense: true,
                                underline: const SizedBox(),
                                items: List.generate(12, (i) => DropdownMenuItem(
                                    value: i + 1,
                                    child: Text(_monthName(context, i + 1)))),
                                onChanged: (m) {
                                  setState(() => _month = m!);
                                  _load();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (ctrl.monthly != null) ...[
                        Text(
                          context.l10n.thisMonth(_monthName(context, _month), _year),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        ),
                        const SizedBox(height: 8),
                        _MonthlyCard(ctrl.monthly!),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: ctrl.carryoverLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.arrow_forward),
                            label: Text(context.l10n.carryOverButton),
                            onPressed: ctrl.carryoverLoading
                                ? null
                                : () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(context.l10n.carryOverTitle),
                                        content: Text(
                                            context.l10n.carryOverContent(_monthName(context, _month), _year)),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.pop(ctx, false),
                                              child: Text(context.l10n.cancel)),
                                          ElevatedButton(
                                              onPressed: () => Navigator.pop(ctx, true),
                                              child: Text(context.l10n.confirm)),
                                        ],
                                      ),
                                    );
                                    if (confirm != true || !mounted) return;
                                    final ok = await context.read<SummaryController>().carryover(
                                        widget.userId, _year, _month);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(ok
                                        ? context.l10n.carriedOverSuccess
                                        : (context.read<SummaryController>().carryoverError ?? 'Failed')),
                                      backgroundColor: ok ? context.appSuccess : context.appDanger,
                                    ));
                                  },
                          ),
                        ),
                        if (ctrl.carryoverError != null) ...[
                          const SizedBox(height: 4),
                          Text(ctrl.carryoverError!,
                              style: TextStyle(color: context.appDanger, fontSize: 12)),
                        ],
                        const SizedBox(height: 20),
                      ],
                      if (ctrl.yearly.isNotEmpty) ...[
                        Text(
                          context.l10n.yearAllMonths(_year),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ...ctrl.yearly.map((s) => _YearlyTile(s, _monthName(context, s.month))),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class _MonthlyCard extends StatelessWidget {
  final dynamic summary;
  const _MonthlyCard(this.summary);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Row(context.l10n.startingBalance, CurrencyFormatter.format(summary.startingBalance)),
            _Row(context.l10n.totalIncome, CurrencyFormatter.format(summary.totalIncome), color: context.appSuccess),
            _Row(context.l10n.totalExpense, CurrencyFormatter.format(summary.totalExpense), color: context.appDanger),
            const Divider(),
            _Row(context.l10n.currentBalance,
                CurrencyFormatter.format(summary.startingBalance + summary.totalIncome - summary.totalExpense),
                color: Theme.of(context).colorScheme.primary, bold: true),
          ],
        ),
      ),
    );
  }
}

class _YearlyTile extends StatelessWidget {
  final dynamic summary;
  final String monthName;
  const _YearlyTile(this.summary, this.monthName);

  @override
  Widget build(BuildContext context) {
    final net = summary.totalIncome - summary.totalExpense;
    return Card(
      child: ListTile(
        title: Text(monthName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            '${context.l10n.income}: ${CurrencyFormatter.formatCompact(summary.totalIncome)} | ${context.l10n.expense}: ${CurrencyFormatter.formatCompact(summary.totalExpense)}'),
        trailing: Text(
          CurrencyFormatter.formatCompact(net),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: net >= 0 ? context.appSuccess : context.appDanger,
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool bold;

  const _Row(this.label, this.value, {this.color, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
