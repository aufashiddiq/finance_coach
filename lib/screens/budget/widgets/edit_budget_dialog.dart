import 'package:flutter/material.dart';
import 'package:finance_coach/models/budget_model.dart';

class EditBudgetDialog extends StatefulWidget {
  final Budget budget;
  final Function(Budget) onBudgetUpdated;

  const EditBudgetDialog({
    super.key,
    required this.budget,
    required this.onBudgetUpdated,
  });

  @override
  State<EditBudgetDialog> createState() => EditBudgetDialogState();
}

class EditBudgetDialogState extends State<EditBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.budget.amount.toString(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.budget.category} Budget'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(
            labelText: 'Budget Amount',
            prefixText: '\$ ',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _updateBudget, child: const Text('Update')),
      ],
    );
  }

  void _updateBudget() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedBudget = widget.budget.copyWith(
        amount: double.parse(_amountController.text),
      );

      widget.onBudgetUpdated(updatedBudget);
      Navigator.pop(context);
    }
  }
}
