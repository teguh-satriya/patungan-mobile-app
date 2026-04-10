import 'package:flutter/material.dart';
import '../budget/budget_screen.dart';
import '../report/report_screen.dart';
import '../summary/summary_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  final int userId;
  final int year;
  final int month;

  const AnalyticsScreen({
    super.key,
    required this.userId,
    required this.year,
    required this.month,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.pie_chart), text: 'Budget'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Reports'),
            Tab(icon: Icon(Icons.calendar_month), text: 'Summary'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BudgetScreen(
            userId: widget.userId,
            year: widget.year,
            month: widget.month,
            showAppBar: false,
          ),
          ReportScreen(
            userId: widget.userId,
            year: widget.year,
            month: widget.month,
            showAppBar: false,
          ),
          SummaryScreen(
            userId: widget.userId,
            year: widget.year,
            month: widget.month,
            showAppBar: false,
          ),
        ],
      ),
    );
  }
}
