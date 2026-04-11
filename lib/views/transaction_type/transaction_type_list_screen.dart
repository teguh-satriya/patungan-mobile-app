import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/transaction_type_controller.dart';
import '../../models/transaction_type/transaction_type_response.dart';
import '../../core/theme.dart';
import '../../core/utils/icon_map.dart';
import '../../core/utils/l10n_ext.dart';
import '../../core/constants/transaction_nature.dart';
import 'transaction_type_form_screen.dart';

class TransactionTypeListScreen extends StatefulWidget {
  final int userId;

  const TransactionTypeListScreen({super.key, required this.userId});

  @override
  State<TransactionTypeListScreen> createState() =>
      _TransactionTypeListScreenState();
}

class _TransactionTypeListScreenState extends State<TransactionTypeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    context.read<TransactionTypeController>().loadByUser(widget.userId);
  }

  void _openForm({TransactionTypeResponse? existing}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionTypeFormScreen(
          userId: widget.userId,
          existing: existing,
        ),
      ),
    );
    _load();
  }

  void _confirmDelete(BuildContext ctx, int id, String? name) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.deleteType),
        content: Text(context.l10n.deleteTypeConfirm(name ?? context.l10n.thisType)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ctx.appDanger),
            onPressed: () async {
              Navigator.pop(ctx);
              final ok =
                  await ctx.read<TransactionTypeController>().delete(id);
              if (!ctx.mounted) return;
              if (ok) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(ctx.l10n.typeDeleted),
                    backgroundColor: ctx.appSuccess,
                  ),
                );
              } else {
                final err = ctx.read<TransactionTypeController>().error;
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text(err ?? 'Error'),
                    backgroundColor: ctx.appDanger,
                  ),
                );
              }
            },
            child: Text(context.l10n.delete, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TransactionTypeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.typesTitle),
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
          : ctrl.types.isEmpty
              ? Center(child: Text(context.l10n.noTypesYet))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: ctrl.types.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (_, i) {
                    final t = ctrl.types[i];
                    final isIncome =
                        t.nature?.toLowerCase() == 'income';
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isIncome
                              ? context.appSuccess.withAlpha(30)
                              : context.appDanger.withAlpha(30),
                          child: Icon(
                            t.icon != null
                                ? iconFromName(t.icon)
                                : (isIncome
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward),
                            color: isIncome
                                ? context.appSuccess
                                : context.appDanger,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          t.name ?? '—',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _NatureBadge(
                                  nature: t.nature,
                                  isIncome: isIncome,
                                ),
                                if (t.icon != null && t.icon!.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  Icon(iconFromName(t.icon),
                                      size: 13, color: Colors.grey),
                                  const SizedBox(width: 3),
                                  Text(
                                    t.icon!
                                        .split('_')
                                        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
                                        .join(' '),
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ],
                            ),
                            if (t.description != null &&
                                t.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  t.description!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        isThreeLine: t.description != null &&
                            t.description!.isNotEmpty,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _openForm(existing: t),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline,
                                  color: context.appDanger),
                              onPressed: () =>
                                  _confirmDelete(context, t.id, t.name),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _NatureBadge extends StatelessWidget {
  final String? nature;
  final bool isIncome;

  const _NatureBadge({this.nature, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isIncome
            ? context.appSuccess.withAlpha(30)
            : context.appDanger.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        nature != null ? TransactionNature.label(nature!) : '—',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isIncome ? context.appSuccess : context.appDanger,
        ),
      ),
    );
  }
}
