import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/summary_controller.dart';
import '../../core/utils/currency_formatter.dart';

class SummaryScreen extends StatefulWidget {
  final int userId;
  final int year;
  final int month;

  const SummaryScreen({
    super.key,
    required this.userId,
    required this.year,
    required this.month,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final ctrl = context.read<SummaryController>();
    ctrl.loadMonthly(widget.userId, widget.year, widget.month);
    ctrl.loadYearly(widget.userId, widget.year);
  }

  String _monthName(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<SummaryController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
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
                      if (ctrl.monthly != null) ...[
                        Text(
                          'This Month — ${_monthName(widget.month)} ${widget.year}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                        ),
                        const SizedBox(height: 8),
                        _MonthlyCard(ctrl.monthly!),
                        const SizedBox(height: 20),
                      ],
                      if (ctrl.yearly.isNotEmpty) ...[
                        Text(
                          'Year ${widget.year} — All Months',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ...ctrl.yearly.map((s) => _YearlyTile(s, _monthName(s.month))),
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
            _Row('Starting Balance', CurrencyFormatter.format(summary.startingBalance)),
            _Row('Total Income', CurrencyFormatter.format(summary.totalIncome), Colors.green),
            _Row('Total Expense', CurrencyFormatter.format(summary.totalExpense), Colors.red),
            _Row('Carried Over', CurrencyFormatter.format(summary.carriedOver), Colors.orange),
            const Divider(),
            _Row('Ending Balance', CurrencyFormatter.format(summary.endingBalance),
                Colors.indigo, bold: true),
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
            'In: ${CurrencyFormatter.formatCompact(summary.totalIncome)} | Out: ${CurrencyFormatter.formatCompact(summary.totalExpense)}'),
        trailing: Text(
          CurrencyFormatter.formatCompact(net),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: net >= 0 ? Colors.green : Colors.red,
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

  const _Row(this.label, this.value, [this.color]);

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
