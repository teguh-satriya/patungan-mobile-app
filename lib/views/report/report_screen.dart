import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/report_controller.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/theme.dart';

class ReportScreen extends StatefulWidget {
  final int userId;
  final int year;
  final int month;

  const ReportScreen({super.key, required this.userId, required this.year, required this.month});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  void _load() {
    context.read<ReportController>().loadAll(widget.userId, widget.year, widget.month);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ReportController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
        bottom: const TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Cash Flow'),
            Tab(text: 'Comparison'),
            Tab(text: 'Trend'),
          ],
        ),
      ),
      body: ctrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                _CashFlowTab(ctrl.cashflow),
                _ComparisonTab(ctrl.comparison),
                _TrendTab(ctrl.trend),
              ],
            ),
    );
  }
}

class _CashFlowTab extends StatelessWidget {
  final dynamic cashflow;
  const _CashFlowTab(this.cashflow);

  @override
  Widget build(BuildContext context) {
    if (cashflow == null) return const Center(child: Text('No data'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
          _InfoCard('Cash Flow Summary', [
          _KV('Opening Balance', CurrencyFormatter.format(cashflow.openingBalance)),
          _KV('Total Income', CurrencyFormatter.format(cashflow.totalIncome), context.appSuccess),
          _KV('Total Expense', CurrencyFormatter.format(cashflow.totalExpense), context.appDanger),
          _KV('Net Cash Flow', CurrencyFormatter.format(cashflow.netCashFlow),
              cashflow.netCashFlow >= 0 ? context.appSuccess : context.appDanger),
          _KV('Closing Balance', CurrencyFormatter.format(cashflow.closingBalance), Theme.of(context).colorScheme.primary),
        ]),
        const SizedBox(height: 12),
        if (cashflow.incomeDetails?.isNotEmpty == true) ...[
          const Text('Income Breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...cashflow.incomeDetails.map<Widget>(
            (d) => ListTile(
              title: Text(d.transactionTypeName ?? ''),
                trailing: Text(CurrencyFormatter.format(d.amount),
                  style: TextStyle(color: context.appSuccess)),
              dense: true,
            ),
          ),
        ],
      ],
    );
  }
}

class _ComparisonTab extends StatelessWidget {
  final dynamic comparison;
  const _ComparisonTab(this.comparison);

  @override
  Widget build(BuildContext context) {
    if (comparison == null) return const Center(child: Text('No data'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoCard('Overall Comparison', [
          _KV('Total Income', CurrencyFormatter.format(comparison.totalIncome), context.appSuccess),
          _KV('Total Expense', CurrencyFormatter.format(comparison.totalExpense), context.appDanger),
          _KV('Net Amount', CurrencyFormatter.format(comparison.netAmount),
              comparison.netAmount >= 0 ? context.appSuccess : context.appDanger),
        ]),
        const SizedBox(height: 12),
        if (comparison.monthlyBreakdown?.isNotEmpty == true) ...[
          const Text('Monthly Breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...comparison.monthlyBreakdown.map<Widget>(
            (m) => Card(
              child: ListTile(
                title: Text('${m.month}/${m.year}'),
                subtitle: Text('Net: ${CurrencyFormatter.format(m.netAmount)}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('↑ ${CurrencyFormatter.formatCompact(m.income)}',
                      style: TextStyle(color: context.appSuccess, fontSize: 12)),
                    Text('↓ ${CurrencyFormatter.formatCompact(m.expense)}',
                      style: TextStyle(color: context.appDanger, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TrendTab extends StatelessWidget {
  final dynamic trend;
  const _TrendTab(this.trend);

  @override
  Widget build(BuildContext context) {
    if (trend == null) return const Center(child: Text('No data'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _InfoCard('Trend Analysis (${trend.monthsAnalyzed} months)', [
          _KV('Avg Income', CurrencyFormatter.format(trend.averageIncome), context.appSuccess),
          _KV('Avg Expense', CurrencyFormatter.format(trend.averageExpense), context.appDanger),
          _KV('Avg Net', CurrencyFormatter.format(trend.averageNetAmount)),
          _KV('Trend Direction', trend.trendDirection ?? 'N/A',
              trend.trendDirection == 'Up' ? context.appSuccess : context.appWarning),
        ]),
        const SizedBox(height: 12),
        if (trend.monthlyTrends?.isNotEmpty == true) ...[
          const Text('Monthly Trends', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...trend.monthlyTrends.map<Widget>(
            (t) => Card(
              child: ListTile(
                title: Text('${t.month}/${t.year}'),
                subtitle: Text('Balance: ${CurrencyFormatter.formatCompact(t.balance)}'),
                trailing: Text(
                  CurrencyFormatter.formatCompact(t.netAmount),
                  style: TextStyle(
                    color: t.netAmount >= 0 ? context.appSuccess : context.appDanger,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> rows;
  const _InfoCard(this.title, this.rows);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _KV extends StatelessWidget {
  final String key_;
  final String value;
  final Color? color;
  const _KV(this.key_, this.value, [this.color]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key_, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
