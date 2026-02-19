import 'package:finance_coach/models/budget_model.dart';
import 'package:flutter/material.dart';

class AddBudgetDialog extends StatefulWidget {
  final Function(Budget) onBudgetAdded;

  const AddBudgetDialog({super.key, required this.onBudgetAdded});

  @override
  State<AddBudgetDialog> createState() => AddBudgetDialogState();
}

class AddBudgetDialogState extends State<AddBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();

  final List<BudgetCategory> _categories = [
    BudgetCategory('Food & Dining', Icons.restaurant, Colors.orange),
    BudgetCategory('Groceries', Icons.shopping_cart, Colors.green),
    BudgetCategory('Entertainment', Icons.movie, Colors.purple),
    BudgetCategory('Transportation', Icons.directions_car, Colors.blue),
    BudgetCategory('Shopping', Icons.shopping_bag, Colors.pink),
    BudgetCategory('Utilities', Icons.flash_on, Colors.amber),
    BudgetCategory('Healthcare', Icons.local_hospital, Colors.red),
    BudgetCategory('Education', Icons.school, Colors.indigo),
    BudgetCategory('Travel', Icons.flight, Colors.teal),
    BudgetCategory('Other', Icons.category, Colors.grey),
  ];

  BudgetCategory? _selectedCategory;

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Budget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<BudgetCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items:
                  _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon, color: category.color, size: 20),
                          const SizedBox(width: 8),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
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
                if (double.tryParse(value) == null ||
                    double.parse(value) <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _saveBudget, child: const Text('Add')),
      ],
    );
  }

  void _saveBudget() {
    if (_formKey.currentState?.validate() ?? false) {
      final budget = Budget(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory!.name,
        amount: double.parse(_amountController.text),
        spent: 0.0,
        icon: _selectedCategory!.icon,
        color: _selectedCategory!.color,
      );

      widget.onBudgetAdded(budget);
      Navigator.pop(context);
    }
  }
}
