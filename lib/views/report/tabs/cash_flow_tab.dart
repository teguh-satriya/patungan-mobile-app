import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/theme.dart';
import '../widgets/report_widgets.dart';

class CashFlowTab extends StatelessWidget {
  final dynamic cashflow;
  final String? error;
  const CashFlowTab(this.cashflow, {super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if (cashflow == null) return Center(child: Text(error ?? 'No data', style: TextStyle(color: error != null ? Colors.red : null)));

    final income = (cashflow.totalIncome as num).toDouble();
    final expense = (cashflow.totalExpense as num).toDouble();
    final total = income + expense;
    final hasData = total > 0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (hasData) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Income vs Expense',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 48,
                        sections: [
                          PieChartSectionData(
                            value: income,
                            color: context.appSuccess,
                            title: '${(income / total * 100).toStringAsFixed(1)}%',
                            titleStyle: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            radius: 60,
                          ),
                          PieChartSectionData(
                            value: expense,
                            color: context.appDanger,
                            title: '${(expense / total * 100).toStringAsFixed(1)}%',
                            titleStyle: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            radius: 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Legend(color: context.appSuccess, label: 'Income'),
                      const SizedBox(width: 24),
                      _Legend(color: context.appDanger, label: 'Expense'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        ReportInfoCard('Cash Flow Summary', [
          ReportKV('Opening Balance', CurrencyFormatter.format(cashflow.openingBalance)),
          ReportKV('Total Income', CurrencyFormatter.format(cashflow.totalIncome), context.appSuccess),
          ReportKV('Total Expense', CurrencyFormatter.format(cashflow.totalExpense), context.appDanger),
          ReportKV('Net Cash Flow', CurrencyFormatter.format(cashflow.netCashFlow),
              cashflow.netCashFlow >= 0 ? context.appSuccess : context.appDanger),
          ReportKV('Closing Balance', CurrencyFormatter.format(cashflow.closingBalance),
              Theme.of(context).colorScheme.primary),
        ]),
        const SizedBox(height: 12),
        if (cashflow.incomeDetails?.isNotEmpty == true) ...[
          const Text('Income Breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...cashflow.incomeDetails.map<Widget>(
            (d) => ListTile(
              title: Text(d.transactionTypeName ?? ''),
              trailing: Text(
                CurrencyFormatter.format(d.amount),
                style: TextStyle(color: context.appSuccess),
              ),
              dense: true,
            ),
          ),
        ],
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

