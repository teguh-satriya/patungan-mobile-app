import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction/transaction_response.dart';
import 'transaction_form_screen.dart';

class TransactionListScreen extends StatefulWidget {
  final int userId;
  final int year;
  final int month;

  const TransactionListScreen({
    super.key,
    required this.userId,
    required this.year,
    required this.month,
  });

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    context
        .read<TransactionController>()
        .loadMonthly(widget.userId, widget.year, widget.month);
  }

  void _openForm({TransactionResponse? existing}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionFormScreen(
          userId: widget.userId,
          existing: existing,
        ),
      ),
    );
    _load();
  }

  void _confirmDelete(BuildContext ctx, int id) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ctx.read<TransactionController>().delete(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TransactionController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ctrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ctrl.transactions.isEmpty
              ? const Center(child: Text('No transactions yet'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: ctrl.transactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (_, i) {
                    final t = ctrl.transactions[i];
                    final isIncome = t.transactionNature?.toLowerCase() == 'income';
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
                          child: Icon(
                            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        title: Text(t.transactionTypeName ?? 'Transaction'),
                        subtitle: Text(
                          '${t.date.toLocal().toString().substring(0, 10)}${t.notes != null ? ' • ${t.notes}' : ''}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          CurrencyFormatter.format(t.amount),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        onTap: () => _openForm(existing: t),
                        onLongPress: () => _confirmDelete(context, t.id),
                      ),
                    );
                  },
                ),
    );
  }
}
