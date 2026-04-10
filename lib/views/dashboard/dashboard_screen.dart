import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/budget_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../controllers/transaction_type_controller.dart';
import '../../core/utils/token_storage.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/theme.dart';
import '../../controllers/theme_controller.dart';
import '../transaction/transaction_list_screen.dart';
import '../analytics/analytics_screen.dart';
import '../transaction_type/transaction_type_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _userId = 0;
  final _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _userId = await TokenStorage.getUserId() ?? 0;
    if (!mounted) return;
    setState(() {});
    _loadData();
  }

  void _loadData() {
    if (_userId == 0) return;
    context.read<BudgetController>().loadAll(_userId, _now.year, _now.month);
    context.read<TransactionController>().loadMonthly(_userId, _now.year, _now.month);
    context.read<TransactionTypeController>().loadByUser(_userId);
  }

  List<Widget> get _pages => [
        _HomeTab(userId: _userId, now: _now),
        TransactionListScreen(userId: _userId, year: _now.year, month: _now.month),
        AnalyticsScreen(userId: _userId, year: _now.year, month: _now.month),
        TransactionTypeListScreen(userId: _userId),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Transactions'),
          NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.category_outlined), selectedIcon: Icon(Icons.category), label: 'Types'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final int userId;
  final DateTime now;

  const _HomeTab({required this.userId, required this.now});

  @override
  Widget build(BuildContext context) {
    final budget = context.watch<BudgetController>();
    final auth = context.watch<AuthController>();
    final monthName = _monthName(now.month);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patungan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(context.read<ThemeController>().mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => context.read<ThemeController>().toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context, auth),
          ),
        ],
      ),
      body: budget.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await budget.loadAll(userId, now.year, now.month);
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Welcome back, ${auth.user?.userName ?? ''}!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$monthName ${now.year}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  if (budget.error != null)
                    Card(
                      color: context.appDanger.withAlpha(25),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(budget.error!, style: TextStyle(color: context.appDanger.withAlpha(220))),
                      ),
                    ),
                  if (budget.overview != null) ...[
                    _BalanceCard(overview: budget.overview!),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      income: budget.overview!.totalIncome,
                      expense: budget.overview!.totalExpense,
                    ),
                    const SizedBox(height: 12),
                    if (budget.projectedBalance != null)
                      _InfoTile(
                          icon: Icons.trending_up,
                          label: 'Projected End Balance',
                          value: CurrencyFormatter.format(budget.projectedBalance!),
                          color: context.appInfo,
                        ),
                    const SizedBox(height: 8),
                    _InfoTile(
                      icon: Icons.swap_horiz,
                      label: 'Carried Over',
                      value: CurrencyFormatter.format(budget.overview!.carriedOverFromPrevious),
                      color: context.appWarning,
                    ),
                    const SizedBox(height: 8),
                    _InfoTile(
                      icon: Icons.receipt,
                      label: 'Transactions',
                      value: budget.overview!.transactionCount.toString(),
                      color: context.appAccent,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  String _monthName(int m) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[m - 1];
  }

  void _confirmLogout(BuildContext context, AuthController auth) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              auth.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: context.appDanger),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final dynamic overview;
  const _BalanceCard({required this.overview});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Current Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(
                overview.currentBalance + overview.carriedOverFromPrevious,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final double income;
  final double expense;
  const _SummaryRow({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniCard(
            label: 'Income',
            value: CurrencyFormatter.formatCompact(income),
            icon: Icons.arrow_downward,
            color: context.appSuccess,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniCard(
            label: 'Expense',
            value: CurrencyFormatter.formatCompact(expense),
            icon: Icons.arrow_upward,
            color: context.appDanger,
          ),
        ),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withAlpha(25),
              radius: 20,
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(25),
          child: Icon(icon, color: color),
        ),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        trailing: Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
