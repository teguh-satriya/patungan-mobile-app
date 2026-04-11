import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/theme.dart';
import '../widgets/report_widgets.dart';

class TrendTab extends StatelessWidget {
  final dynamic trend;
  final String? error;
  const TrendTab(this.trend, {super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if (trend == null) return Center(child: Text(error ?? 'No data', style: TextStyle(color: error != null ? Colors.red : null)));

    final months = trend.monthlyTrends;
    final hasMonths = months != null && (months as List).isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ReportInfoCard('Trend Analysis (${trend.monthsAnalyzed} months)', [
          ReportKV('Avg Income', CurrencyFormatter.format(trend.averageIncome), context.appSuccess),
          ReportKV('Avg Expense', CurrencyFormatter.format(trend.averageExpense), context.appDanger),
          ReportKV('Avg Net', CurrencyFormatter.format(trend.averageNetAmount)),
          ReportKV('Trend Direction', trend.trendDirection ?? 'N/A',
              trend.trendDirection == 'Up' ? context.appSuccess : context.appWarning),
        ]),
        const SizedBox(height: 12),
        if (hasMonths) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Balance History',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              (months as List).length,
                              (i) => FlSpot(i.toDouble(), (months[i].balance as num).toDouble()),
                            ),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 2.5,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              getTitlesWidget: (value, meta) {
                                final i = value.toInt();
                                if (i < 0 || i >= (months as List).length) return const SizedBox();
                                final t = months[i];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    '${t.month}/${t.year % 100}',
                                    style: const TextStyle(fontSize: 9),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 56,
                              getTitlesWidget: (value, meta) => Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  CurrencyFormatter.formatCompact(value),
                                  style: const TextStyle(fontSize: 9),
                                ),
                              ),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Monthly Trends', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...(months as List).map<Widget>(
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
