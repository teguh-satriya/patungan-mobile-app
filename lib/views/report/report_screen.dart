import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/report_controller.dart';
import '../../core/theme.dart';
import 'tabs/cash_flow_tab.dart';
import 'tabs/comparison_tab.dart';
import 'tabs/trend_tab.dart';
import 'tabs/carryover_tab.dart';

class ReportScreen extends StatefulWidget {
  final int userId;
  final int year;
  final int month;

  const ReportScreen({super.key, required this.userId, required this.year, required this.month, this.showAppBar = true});

  final bool showAppBar;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
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
    final tabBar = TabBar(
      controller: _tabs,
      labelColor: widget.showAppBar ? Colors.white : Theme.of(context).colorScheme.primary,
      unselectedLabelColor: widget.showAppBar ? Colors.white60 : null,
      indicatorColor: widget.showAppBar ? Colors.white : Theme.of(context).colorScheme.primary,
      tabs: const [
        Tab(text: 'Cash Flow'),
        Tab(text: 'Comparison'),
        Tab(text: 'Trend'),
        Tab(text: 'Carryover'),
      ],
    );
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Reports'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              automaticallyImplyLeading: false,
              actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
              bottom: tabBar,
            )
          : PreferredSize(
              preferredSize: tabBar.preferredSize,
              child: tabBar,
            ),
      body: ctrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                CashFlowTab(ctrl.cashflow, error: ctrl.cashflowError),
                ComparisonTab(userId: widget.userId),
                TrendTab(ctrl.trend, error: ctrl.trendError),
                CarryoverTab(userId: widget.userId),
              ],
            ),
    );
  }
}
