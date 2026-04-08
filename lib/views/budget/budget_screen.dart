import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/budget_controller.dart';
import '../../core/utils/currency_formatter.dart';

class BudgetScreen extends StatefulWidget {
  final int userId;
  final int year;
  final int month;

  const BudgetScreen({super.key, required this.userId, required this.year, required this.month});

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
      appBar: AppBar(
        title: const Text('Budget'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: ctrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ctrl.error != null
              ? Center(child: Text(ctrl.error!, style: const TextStyle(color: Colors.red)))
              : RefreshIndicator(
                  onRefresh: () async => _load(),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (ctrl.overview != null) ...[
                        _SectionHeader('Overview – ${widget.month}/${widget.year}'),
                        const SizedBox(height: 8),
                        _OverviewCard(ctrl.overview),
                        const SizedBox(height: 16),
                      ],
                      if (ctrl.spendingByType.isNotEmpty) ...[
                        const _SectionHeader('Spending by Category'),
                        const SizedBox(height: 8),
                        ...ctrl.spendingByType.map((t) => _CategoryTile(t)),
                        const SizedBox(height: 16),
                      ],
                      if (ctrl.carryoverHistory != null) ...[
                        const _SectionHeader('Carryover History'),
                        const SizedBox(height: 8),
                        _CarryoverCard(ctrl.carryoverHistory!),
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
          ?.copyWith(fontWeight: FontWeight.bold, color: Colors.indigo),
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
            _Row('Starting Balance', CurrencyFormatter.format(overview.startingBalance)),
            _Row('Total Income', CurrencyFormatter.format(overview.totalIncome), color: Colors.green),
            _Row('Total Expense', CurrencyFormatter.format(overview.totalExpense), color: Colors.red),
            const Divider(),
            _Row('Current Balance', CurrencyFormatter.format(overview.currentBalance),
              color: Colors.indigo, bold: true),
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
          backgroundColor: (isIncome ? Colors.green : Colors.red).withAlpha(25),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green : Colors.red,
            size: 18,
          ),
        ),
        title: Text(type.transactionTypeName ?? ''),
        subtitle: Text('${type.transactionCount} transactions • ${type.percentage.toStringAsFixed(1)}%'),
        trailing: Text(
          CurrencyFormatter.formatCompact(type.totalAmount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}

class _CarryoverCard extends StatelessWidget {
  final dynamic history;
  const _CarryoverCard(this.history);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Row('Total Carried Over', CurrencyFormatter.format(history.totalCarriedOver), color: Colors.orange),
            _Row('Average Carryover', CurrencyFormatter.format(history.averageCarryover)),
          ],
        ),
      ),
    );
  }
}
