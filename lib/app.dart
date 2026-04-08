import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'controllers/budget_controller.dart';
import 'controllers/summary_controller.dart';
import 'controllers/report_controller.dart';
import 'controllers/transaction_controller.dart';
import 'views/auth/login_screen.dart';
import 'views/dashboard/dashboard_screen.dart';

class PatunganApp extends StatelessWidget {
  const PatunganApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => BudgetController()),
        ChangeNotifierProvider(create: (_) => SummaryController()),
        ChangeNotifierProvider(create: (_) => ReportController()),
        ChangeNotifierProvider(create: (_) => TransactionController()),
      ],
      child: MaterialApp(
        title: 'Patungan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthController>().checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthController>().status;
    switch (status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.authenticated:
        return const DashboardScreen();
      case AuthStatus.unauthenticated:
        return const LoginScreen();
    }
  }
}
