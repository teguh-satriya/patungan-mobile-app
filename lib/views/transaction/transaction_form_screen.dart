import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../controllers/transaction_controller.dart';
import '../../controllers/transaction_type_controller.dart';
import '../../models/transaction/transaction_response.dart';
import '../../models/transaction/create_transaction_request.dart';
import '../../models/transaction/update_transaction_request.dart';
import '../../core/theme.dart';

class TransactionFormScreen extends StatefulWidget {
  final int userId;
  final TransactionResponse? existing;

  const TransactionFormScreen({super.key, required this.userId, this.existing});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  int? _selectedTypeId;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final t = widget.existing!;
      _amountCtrl.text = _formatThousands(t.amount.toStringAsFixed(0));
      _notesCtrl.text = t.notes ?? '';
      _selectedTypeId = t.transactionTypeId;
      _selectedDate = t.date;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final typeCtrl = context.read<TransactionTypeController>();
      if (typeCtrl.types.isEmpty) {
        typeCtrl.loadByUser(widget.userId);
      }
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a transaction type'),
          backgroundColor: context.appDanger,
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    final ctrl = context.read<TransactionController>();
    final dateStr = _selectedDate.toIso8601String().substring(0, 10);
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '')) ?? 0;
    final typeId = _selectedTypeId!;
    final notes = _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null;

    bool ok;
    if (_isEditing) {
      ok = await ctrl.update(
        widget.existing!.id,
        UpdateTransactionRequest(
          transactionTypeId: typeId,
          date: dateStr,
          amount: amount,
          notes: notes,
        ),
      );
    } else {
      ok = await ctrl.create(
        CreateTransactionRequest(
          userId: widget.userId,
          transactionTypeId: typeId,
          date: dateStr,
          amount: amount,
          notes: notes,
        ),
      );
    }

    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.successMessage ?? 'Done'),
          backgroundColor: context.appSuccess,
        ),
      );
    } else {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ctrl.error ?? 'Error'), backgroundColor: context.appDanger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeCtrl = context.watch<TransactionTypeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'New Transaction'),
      backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              typeCtrl.isLoading
                  ? const InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Transaction Type',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : DropdownButtonFormField<int>(
                      initialValue: _selectedTypeId,
                      decoration: const InputDecoration(
                        labelText: 'Transaction Type',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: typeCtrl.types
                          .map(
                            (t) => DropdownMenuItem(
                              value: t.id,
                              child: Text(t.name ?? '—'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedTypeId = v),
                      validator: (v) => v == null ? 'Required' : null,
                    ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [_ThousandsSeparatorFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final raw = v.replaceAll(',', '');
                  if (double.tryParse(raw) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: const BorderSide(color: Colors.grey),
                ),
                leading: const Icon(Icons.calendar_today),
                title: Text('Date: ${_selectedDate.toIso8601String().substring(0, 10)}'),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Update' : 'Save',
                        style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatThousands(String digits) {
  if (digits.isEmpty) return '';
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    if (i > 0 && remaining % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits and one decimal point
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    // Split integer and decimal parts
    final parts = digits.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';

    final formatted = _formatThousands(intPart) + decPart;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
