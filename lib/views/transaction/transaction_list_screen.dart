import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/utils/l10n_ext.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/icon_map.dart';
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
        title: Text(context.l10n.deleteTransaction),
        content: Text(context.l10n.areYouSure),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ctx.appDanger),
            onPressed: () async {
              Navigator.pop(ctx);
              await ctx.read<TransactionController>().delete(id);
            },
            child: Text(context.l10n.delete, style: const TextStyle(color: Colors.white)),
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
        title: Text(context.l10n.transactionsTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ctrl.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ctrl.transactions.isEmpty
              ? Center(child: Text(context.l10n.noTransactionsYet))
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
                          backgroundColor: (isIncome ? context.appSuccess : context.appDanger).withAlpha(25),
                          child: Icon(
                            t.transactionTypeIcon != null
                                ? iconFromName(t.transactionTypeIcon)
                                : (isIncome ? Icons.arrow_downward : Icons.arrow_upward),
                            color: isIncome ? context.appSuccess : context.appDanger,
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
                            color: isIncome ? context.appSuccess : context.appDanger,
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
