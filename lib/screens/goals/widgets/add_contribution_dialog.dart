import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finance_coach/models/goal_model.dart';

class AddContributionDialog extends StatefulWidget {
  final FinancialGoal goal;
  final Function(double) onContributionAdded;

  const AddContributionDialog({
    super.key,
    required this.goal,
    required this.onContributionAdded,
  });

  @override
  State<AddContributionDialog> createState() => AddContributionDialogState();
}

class AddContributionDialogState extends State<AddContributionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final remaining = widget.goal.targetAmount - widget.goal.currentAmount;

    return AlertDialog(
      title: Text('Add to ${widget.goal.name}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current: ${currencyFormat.format(widget.goal.currentAmount)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Remaining: ${currencyFormat.format(remaining)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Contribution Amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null ||
                    double.parse(value) <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildQuickAmount(remaining * 0.25, '25%'),
                const SizedBox(width: 8),
                _buildQuickAmount(remaining * 0.5, '50%'),
                const SizedBox(width: 8),
                _buildQuickAmount(remaining, 'All'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _addContribution, child: const Text('Add')),
      ],
    );
  }

  Widget _buildQuickAmount(double amount, String label) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          _amountController.text = amount.toStringAsFixed(2);
        },
        child: Text(label),
      ),
    );
  }

  void _addContribution() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text);
      widget.onContributionAdded(amount);
      Navigator.pop(context);
    }
  }
}
