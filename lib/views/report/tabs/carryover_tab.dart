import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/report_controller.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/theme.dart';
import '../../../models/budget/carryover_history_response.dart';
import '../widgets/report_widgets.dart';

class CarryoverTab extends StatefulWidget {
  final int userId;
  const CarryoverTab({required this.userId, super.key});

  @override
  State<CarryoverTab> createState() => _CarryoverTabState();
}

class _CarryoverTabState extends State<CarryoverTab> {
  int _fromYear = DateTime.now().year - 1;
  int _fromMonth = 1;
  int _toYear = DateTime.now().year;
  int _toMonth = DateTime.now().month;

  void _load() {
    context.read<ReportController>().loadCarryoverHistory(
        widget.userId, _fromYear, _fromMonth, _toYear, _toMonth);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ReportController>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('From', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                          const Text('To', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                    onPressed: ctrl.carryoverLoading ? null : _load,
                    child: ctrl.carryoverLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Show'),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (ctrl.carryoverError != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(ctrl.carryoverError!, style: TextStyle(color: context.appDanger)),
          ),
        if (ctrl.carryoverHistory != null) ...[
          const SizedBox(height: 12),
          _CarryoverSummaryCard(ctrl.carryoverHistory!),
          const SizedBox(height: 12),
          if (ctrl.carryoverHistory!.history?.isNotEmpty == true) ...[
            const Text('Monthly Detail', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...ctrl.carryoverHistory!.history!.map((item) => Card(
                  child: ListTile(
                    title: Text('${item.month}/${item.year}'),
                    subtitle: Text(
                        'Start: ${CurrencyFormatter.formatCompact(item.startingBalance)}  →  End: ${CurrencyFormatter.formatCompact(item.endingBalance)}'),
                    trailing: Text(
                      CurrencyFormatter.format(item.carriedOver),
                      style: TextStyle(color: context.appWarning, fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ],
      ],
    );
  }
}

class _CarryoverSummaryCard extends StatelessWidget {
  final CarryoverHistoryResponse history;
  const _CarryoverSummaryCard(this.history);

  @override
  Widget build(BuildContext context) {
    return ReportInfoCard('Carryover Summary', [
      ReportKV('Total Carried Over', CurrencyFormatter.format(history.totalCarriedOver),
          context.appWarning),
      ReportKV('Average Carryover', CurrencyFormatter.format(history.averageCarryover)),
    ]);
  }
}
