import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/budget_controller.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/icon_map.dart';
import '../../core/utils/l10n_ext.dart';
import '../../core/theme.dart';

class BudgetScreen extends StatefulWidget {
  final int userId;
  final int year;
  final int month;

  const BudgetScreen({super.key, required this.userId, required this.year, required this.month, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    context.read<BudgetController>().loadAll(widget.userId, widget.year, widget.month);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<BudgetController>();
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(context.l10n.budgetTitle),
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
                      if (ctrl.overview != null) ...[
                        _SectionHeader(context.l10n.overviewHeader('${widget.month}', widget.year)),
                        const SizedBox(height: 8),
                        _OverviewCard(ctrl.overview),
                        const SizedBox(height: 16),
                      ],
                      if (ctrl.spendingByType.isNotEmpty) ...[
                        _SectionHeader(context.l10n.spendingByCategory),
                        const SizedBox(height: 8),
                        ...ctrl.spendingByType.map((t) => _CategoryTile(t)),
                        const SizedBox(height: 16),
                      ],

                    ],
                  ),
                ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final dynamic overview;
  const _OverviewCard(this.overview);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Row(context.l10n.startingBalance, CurrencyFormatter.format(overview.startingBalance)),
            _Row(context.l10n.totalIncome, CurrencyFormatter.format(overview.totalIncome), color: context.appSuccess),
            _Row(context.l10n.totalExpense, CurrencyFormatter.format(overview.totalExpense), color: context.appDanger),
            const Divider(),
            _Row(
              context.l10n.currentBalance,
              CurrencyFormatter.format(overview.currentBalance),
              color: Theme.of(context).colorScheme.primary,
              bold: true,
            ),
          ],
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

class _CategoryTile extends StatelessWidget {
  final dynamic type;
  const _CategoryTile(this.type);

  @override
  Widget build(BuildContext context) {
    final isIncome = type.nature?.toLowerCase() == 'income';
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (isIncome ? context.appSuccess : context.appDanger).withAlpha(25),
          child: Icon(
            type.icon != null
                ? iconFromName(type.icon)
                : (isIncome ? Icons.arrow_downward : Icons.arrow_upward),
            color: isIncome ? context.appSuccess : context.appDanger,
            size: 18,
          ),
        ),
        title: Text(type.transactionTypeName ?? ''),
        subtitle: Text('${type.transactionCount} transactions • ${type.percentage.toStringAsFixed(1)}%'),
        trailing: Text(
          CurrencyFormatter.formatCompact(type.totalAmount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? context.appSuccess : context.appDanger,
          ),
        ),
      ),
    );
  }
}


