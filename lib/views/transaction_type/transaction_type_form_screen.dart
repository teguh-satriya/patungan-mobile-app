import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/transaction_type_controller.dart';
import '../../models/transaction_type/transaction_type_response.dart';
import '../../models/transaction_type/create_transaction_type_request.dart';
import '../../models/transaction_type/update_transaction_type_request.dart';
import '../../core/theme.dart';
import '../../core/utils/icon_map.dart';
import '../../core/constants/transaction_nature.dart';

class TransactionTypeFormScreen extends StatefulWidget {
  final int userId;
  final TransactionTypeResponse? existing;

  const TransactionTypeFormScreen({
    super.key,
    required this.userId,
    this.existing,
  });

  @override
  State<TransactionTypeFormScreen> createState() =>
      _TransactionTypeFormScreenState();
}

class _TransactionTypeFormScreenState
    extends State<TransactionTypeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  String _selectedNature = TransactionNature.income;
  String? _selectedIcon;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final t = widget.existing!;
      _nameCtrl.text = t.name ?? '';
      _descriptionCtrl.text = t.description ?? '';
      _selectedNature = (t.nature?.toLowerCase() == TransactionNature.outcome)
          ? TransactionNature.outcome
          : TransactionNature.income;
      _selectedIcon =
          (t.icon != null && kIconMap.containsKey(t.icon)) ? t.icon : null;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickIcon() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _IconPickerSheet(),
    );
    if (picked != null) setState(() => _selectedIcon = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ctrl = context.read<TransactionTypeController>();
    final name = _nameCtrl.text.trim();
    final description = _descriptionCtrl.text.trim().isNotEmpty
        ? _descriptionCtrl.text.trim()
        : null;

    bool ok;
    if (_isEditing) {
      ok = await ctrl.update(
        UpdateTransactionTypeRequest(
          id: widget.existing!.id,
          userId: widget.userId,
          name: name,
          nature: _selectedNature,
          description: description,
          icon: _selectedIcon,
        ),
      );
    } else {
      ok = await ctrl.create(
        CreateTransactionTypeRequest(
          userId: widget.userId,
          name: name,
          nature: _selectedNature,
          description: description,
          icon: _selectedIcon,
        ),
      );
    }

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.successMessage ?? 'Done'),
          backgroundColor: context.appSuccess,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ctrl.error ?? 'Error'),
          backgroundColor: context.appDanger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TransactionTypeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Type' : 'New Type'),
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
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.label_outlined),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedNature,
                decoration: const InputDecoration(
                  labelText: 'Nature',
                  prefixIcon: Icon(Icons.swap_vert),
                  border: OutlineInputBorder(),
                ),
                items: TransactionNature.values
                    .map((v) => DropdownMenuItem(
                          value: v,
                          child: Text(TransactionNature.label(v)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedNature = v);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Icon picker tile
              InkWell(
                onTap: _pickIcon,
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Icon (optional)',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(25),
                        child: Icon(
                          _selectedIcon != null
                              ? kIconMap[_selectedIcon]!
                              : Icons.add_photo_alternate_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedIcon != null
                              ? _selectedIcon!
                                  .split('_')
                                  .map((w) => w.isEmpty
                                      ? ''
                                      : '${w[0].toUpperCase()}${w.substring(1)}')
                                  .join(' ')
                              : 'Tap to choose an icon',
                          style: TextStyle(
                            color: _selectedIcon != null
                                ? Theme.of(context).colorScheme.onSurface
                                : Colors.grey,
                          ),
                        ),
                      ),
                      if (_selectedIcon != null)
                        IconButton(
                          icon:
                              const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: () => setState(() => _selectedIcon = null),
                          tooltip: 'Clear icon',
                        )
                      else
                        const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: ctrl.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: ctrl.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        _isEditing ? 'Update' : 'Save',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Icon Picker Bottom Sheet ─────────────────────────────────────────────────

class _IconPickerSheet extends StatefulWidget {
  const _IconPickerSheet();

  @override
  State<_IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<_IconPickerSheet> {
  final _searchCtrl = TextEditingController();
  List<MapEntry<String, IconData>> _filtered = kIconMap.entries.toList();

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? kIconMap.entries.toList()
          : kIconMap.entries
              .where((e) => e.key.replaceAll('_', ' ').contains(q))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) {
        final isSearching = _searchCtrl.text.trim().isNotEmpty;
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Choose an Icon',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search icons…',
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                          },
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isSearching
                  ? (_filtered.isEmpty
                      ? const Center(child: Text('No icons found'))
                      : GridView.builder(
                          controller: scrollCtrl,
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) {
                            final entry = _filtered[i];
                            return _IconCell(
                              name: entry.key,
                              iconData: entry.value,
                              onTap: () => Navigator.pop(context, entry.key),
                            );
                          },
                        ))
                  : CustomScrollView(
                      controller: scrollCtrl,
                      slivers: [
                        for (final category in kIconCategories.entries) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                children: [
                                  Text(
                                    category.key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Divider(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withAlpha(60),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            sliver: SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (_, i) {
                                  final key = category.value[i];
                                  final iconData = kIconMap[key] ?? Icons.label_outline;
                                  return _IconCell(
                                    name: key,
                                    iconData: iconData,
                                    onTap: () =>
                                        Navigator.pop(context, key),
                                  );
                                },
                                childCount: category.value.length,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.85,
                              ),
                            ),
                          ),
                        ],
                        const SliverToBoxAdapter(
                            child: SizedBox(height: 24)),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _IconCell extends StatelessWidget {
  final String name;
  final IconData iconData;
  final VoidCallback onTap;

  const _IconCell({
    required this.name,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 28, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            name
                .split('_')
                .map((w) => w.isEmpty
                    ? ''
                    : '${w[0].toUpperCase()}${w.substring(1)}')
                .join('\n'),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
