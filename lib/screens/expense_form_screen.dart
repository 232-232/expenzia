import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../state/expense_store.dart';
import '../theme.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Expense? expense;
  const ExpenseFormScreen({super.key, this.expense});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  static const _types = ['Expense', 'Income'];
  static const _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Salary',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _desc;
  late String _type;
  String? _category;
  late DateTime _date;
  bool _saving = false;

  bool get _isEdit => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final e = widget.expense;
    _title = TextEditingController(text: e?.title ?? '');
    _amount = TextEditingController(text: e == null ? '' : e.amount.toString());
    _desc = TextEditingController(text: e?.description ?? '');
    _type = e?.type ?? 'Expense';
    _category = e?.category;
    _date = e?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final e = Expense(
      id: widget.expense?.id,
      type: _type,
      title: _title.text.trim(),
      amount: double.parse(_amount.text.trim()),
      category: _category!,
      date: _date,
      description: _desc.text.trim(),
    );
    final store = ExpenseStore.instance;
    final ok = _isEdit ? await store.update(e) : await store.add(e);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(store.error ?? 'Could not save')));
    }
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 14),
        child: Text(t,
            style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Transaction' : 'Transaction',
              style: const TextStyle(fontSize: 16)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('TRANSACTION TYPE'),
                          DropdownButtonFormField<String>(
                            value: _type,
                            items: _types
                                .map((t) =>
                                    DropdownMenuItem(value: t, child: Text(t)))
                                .toList(),
                            onChanged: (v) => setState(() => _type = v!),
                          ),
                          _label('NAME'),
                          TextFormField(
                            controller: _title,
                            textCapitalization: TextCapitalization.sentences,
                            decoration:
                                const InputDecoration(hintText: 'e.g. Netflix'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Please enter a title'
                                : null,
                          ),
                          _label('AMOUNT'),
                          TextFormField(
                            controller: _amount,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                              hintText: '₹ 0.00',
                              suffixIcon: TextButton(
                                onPressed: _amount.clear,
                                child: const Text('Clear',
                                    style: TextStyle(fontSize: 10)),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter an amount';
                              }
                              final n = double.tryParse(v.trim());
                              if (n == null) return 'Enter a valid number';
                              if (n <= 0)
                                return 'Amount must be greater than 0';
                              return null;
                            },
                          ),
                          _label('CATEGORY'),
                          DropdownButtonFormField<String>(
                            value: _category,
                            hint: const Text('Select category'),
                            items: _categories
                                .map((c) =>
                                    DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) => setState(() => _category = v),
                            validator: (v) =>
                                v == null ? 'Please select a category' : null,
                          ),
                          _label('DATE'),
                          InkWell(
                            onTap: _pickDate,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.calendar_today, size: 16)),
                              child: Text(
                                  DateFormat('EEE, dd MMM yyyy').format(_date)),
                            ),
                          ),
                          _label('DESCRIPTION (OPTIONAL)'),
                          TextFormField(
                            controller: _desc,
                            maxLines: 3,
                            decoration:
                                const InputDecoration(hintText: 'Add a note'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
