import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction/transaction_response.dart';
import '../../models/transaction/create_transaction_request.dart';
import '../../models/transaction/update_transaction_request.dart';

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
  final _typeIdCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final t = widget.existing!;
      _amountCtrl.text = t.amount.toString();
      _notesCtrl.text = t.notes ?? '';
      _typeIdCtrl.text = t.transactionTypeId.toString();
      _selectedDate = t.date;
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    _typeIdCtrl.dispose();
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
    final ctrl = context.read<TransactionController>();
    final dateStr = _selectedDate.toIso8601String().substring(0, 10);
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final typeId = int.tryParse(_typeIdCtrl.text) ?? 0;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.successMessage ?? 'Done'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ctrl.error ?? 'Error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TransactionController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'New Transaction'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _typeIdCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Transaction Type ID',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                  helperText: 'Enter the type ID (e.g. 1=Salary, 2=Food)',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid number';
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
                onPressed: ctrl.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: ctrl.isLoading
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
