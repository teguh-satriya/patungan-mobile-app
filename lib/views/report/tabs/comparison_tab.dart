import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/report_controller.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../core/theme.dart';
import '../widgets/report_widgets.dart';

class ComparisonTab extends StatefulWidget {
  final int userId;
  const ComparisonTab({required this.userId, super.key});

  @override
  State<ComparisonTab> createState() => _ComparisonTabState();
}

class _ComparisonTabState extends State<ComparisonTab> {
  int _fromYear = DateTime.now().year;
  int _fromMonth = 1;
  int _toYear = DateTime.now().year;
  int _toMonth = DateTime.now().month;

  void _load() {
    context.read<ReportController>().loadComparison(
        widget.userId, _fromYear, _fromMonth, _toYear, _toMonth);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ReportController>();
    final comparison = ctrl.comparison;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.selectDateRange, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.from, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Row(
                            children: [
                              DropdownButton<int>(
                                value: _fromYear,
                                isDense: true,
                                items: List.generate(10, (i) {
                                  final y = DateTime.now().year - i;
                                  return DropdownMenuItem(value: y, child: Text('$y'));
                                }),
                                onChanged: (y) => setState(() => _fromYear = y!),
                              ),
                              const SizedBox(width: 4),
                              DropdownButton<int>(
                                value: _fromMonth,
                                isDense: true,
                                items: List.generate(12, (i) => DropdownMenuItem(
                                    value: i + 1, child: Text('${i + 1}'))),
                                onChanged: (m) => setState(() => _fromMonth = m!),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.to, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Row(
                            children: [
                              DropdownButton<int>(
                                value: _toYear,
                                isDense: true,
                                items: List.generate(10, (i) {
                                  final y = DateTime.now().year - i;
                                  return DropdownMenuItem(value: y, child: Text('$y'));
                                }),
                                onChanged: (y) => setState(() => _toYear = y!),
                              ),
                              const SizedBox(width: 4),
                              DropdownButton<int>(
                                value: _toMonth,
                                isDense: true,
                                items: List.generate(12, (i) => DropdownMenuItem(
                                    value: i + 1, child: Text('${i + 1}'))),
                                onChanged: (m) => setState(() => _toMonth = m!),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ctrl.comparisonLoading ? null : _load,
                    child: ctrl.comparisonLoading
                        ? const SizedBox(
                            height: 18, width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(context.l10n.show),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (ctrl.comparisonError != null)
          Center(child: Text(ctrl.comparisonError!, style: const TextStyle(color: Colors.red)))
        else if (comparison == null)
          Center(child: Text(context.l10n.selectDateRangePrompt))
        else ...[
          ReportInfoCard(context.l10n.overallComparison, [
            ReportKV(context.l10n.totalIncome, CurrencyFormatter.format(comparison.totalIncome), context.appSuccess),
            ReportKV(context.l10n.totalExpense, CurrencyFormatter.format(comparison.totalExpense), context.appDanger),
            ReportKV(context.l10n.netAmount, CurrencyFormatter.format(comparison.netAmount),
                comparison.netAmount >= 0 ? context.appSuccess : context.appDanger),
          ]),
          const SizedBox(height: 12),
          if (comparison.monthlyBreakdown?.isNotEmpty == true) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.incomeVsExpensePerMonth,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          maxY: comparison.monthlyBreakdown!
                                  .fold(0.0, (prev, m) {
                                    final mx = m.income > m.expense ? m.income : m.expense;
                                    return mx > prev ? mx : prev;
                                  }) *
                              1.25,
                          barGroups: List.generate(
                            comparison.monthlyBreakdown!.length,
                            (i) {
                              final m = comparison.monthlyBreakdown![i];
                              return BarChartGroupData(
                                x: i,
                                barsSpace: 3,
                                barRods: [
                                  BarChartRodData(
                                    toY: m.income,
                                    color: context.appSuccess,
                                    width: 10,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  BarChartRodData(
                                    toY: m.expense,
                                    color: context.appDanger,
                                    width: 10,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ],
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) {
                                  final i = value.toInt();
                                  final items = comparison.monthlyBreakdown!;
                                  if (i < 0 || i >= items.length) return const SizedBox();
                                  final m = items[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${m.month}/${m.year % 100}',
                                      style: const TextStyle(fontSize: 9),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 52,
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
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Legend(color: context.appSuccess, label: context.l10n.income),
                        const SizedBox(width: 24),
                        _Legend(color: context.appDanger, label: context.l10n.expense),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(context.l10n.monthlyBreakdown, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...comparison.monthlyBreakdown!.map<Widget>(
              (m) => Card(
                child: ListTile(
                  title: Text('${m.month}/${m.year}'),
                  subtitle: Text('${context.l10n.netAmount}: ${CurrencyFormatter.format(m.netAmount)}'),
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

