import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final currencyFormat = NumberFormat.currency(symbol: '\$');
  String _selectedPeriod = 'May 2025';

  // Mock data
  final List<Budget> _budgets = [
    Budget(
      id: '1',
      category: 'Food & Dining',
      amount: 500.0,
      spent: 320.0,
      icon: Icons.restaurant,
      color: Colors.orange,
    ),
    Budget(
      id: '2',
      category: 'Groceries',
      amount: 300.0,
      spent: 250.0,
      icon: Icons.shopping_cart,
      color: Colors.green,
    ),
    Budget(
      id: '3',
      category: 'Entertainment',
      amount: 150.0,
      spent: 110.0,
      icon: Icons.movie,
      color: Colors.purple,
    ),
    Budget(
      id: '4',
      category: 'Transportation',
      amount: 200.0,
      spent: 120.0,
      icon: Icons.directions_car,
      color: Colors.blue,
    ),
    Budget(
      id: '5',
      category: 'Shopping',
      amount: 150.0,
      spent: 75.0,
      icon: Icons.shopping_bag,
      color: Colors.pink,
    ),
    Budget(
      id: '6',
      category: 'Utilities',
      amount: 200.0,
      spent: 180.0,
      icon: Icons.flash_on,
      color: Colors.amber,
    ),
    Budget(
      id: '7',
      category: 'Healthcare',
      amount: 100.0,
      spent: 45.0,
      icon: Icons.local_hospital,
      color: Colors.red,
    ),
  ];

  double get totalBudget =>
      _budgets.fold(0.0, (sum, budget) => sum + budget.amount);
  double get totalSpent =>
      _budgets.fold(0.0, (sum, budget) => sum + budget.spent);
  double get remainingBudget => totalBudget - totalSpent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddBudgetDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Budget summary header
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24.0),
                bottomRight: Radius.circular(24.0),
              ),
            ),
            child: Column(
              children: [
                // Period selector
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      dropdownColor: Theme.of(context).primaryColor,
                      style: const TextStyle(color: Colors.white),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items:
                          ['April 2025', 'May 2025', 'June 2025']
                              .map(
                                (period) => DropdownMenuItem(
                                  value: period,
                                  child: Text(period),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedPeriod = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Budget summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      'Total Budget',
                      currencyFormat.format(totalBudget),
                      Colors.white,
                    ),
                    _buildSummaryItem(
                      'Spent',
                      currencyFormat.format(totalSpent),
                      Colors.white70,
                    ),
                    _buildSummaryItem(
                      'Remaining',
                      currencyFormat.format(remainingBudget),
                      remainingBudget >= 0
                          ? Colors.green[300]!
                          : Colors.red[300]!,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Progress bar
                Container(
                  width: double.infinity,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (totalSpent / totalBudget).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            totalSpent > totalBudget
                                ? Colors.red
                                : Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),

                Text(
                  '${((totalSpent / totalBudget) * 100).toStringAsFixed(1)}% of budget used',
                  style: const TextStyle(color: Colors.white70, fontSize: 14.0),
                ),
              ],
            ),
          ),

          // Budget categories list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _budgets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildBudgetCard(_budgets[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14.0),
        ),
        const SizedBox(height: 4.0),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    final double progress = (budget.spent / budget.amount).clamp(0.0, 1.0);
    final bool isOverBudget = budget.spent > budget.amount;
    final double remaining = budget.amount - budget.spent;

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _editBudget(budget),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => _deleteBudget(budget),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: budget.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(budget.icon, color: budget.color, size: 24.0),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.category,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isOverBudget
                            ? 'Over by ${currencyFormat.format(budget.spent - budget.amount)}'
                            : '${currencyFormat.format(remaining)} remaining',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isOverBudget ? Colors.red : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormat.format(budget.spent),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOverBudget ? Colors.red : null,
                      ),
                    ),
                    Text(
                      'of ${currencyFormat.format(budget.amount)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Progress bar
            Container(
              width: double.infinity,
              height: 8.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: isOverBudget ? Colors.red : budget.color,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Progress percentage
            Text(
              '${(progress * 100).toStringAsFixed(1)}% used',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBudgetDialog() {
    showDialog(
      context: context,
      builder:
          (context) => _AddBudgetDialog(
            onBudgetAdded: (budget) {
              setState(() {
                _budgets.add(budget);
              });
            },
          ),
    );
  }

  void _editBudget(Budget budget) {
    showDialog(
      context: context,
      builder:
          (context) => _EditBudgetDialog(
            budget: budget,
            onBudgetUpdated: (updatedBudget) {
              setState(() {
                final index = _budgets.indexWhere((b) => b.id == budget.id);
                if (index != -1) {
                  _budgets[index] = updatedBudget;
                }
              });
            },
          ),
    );
  }

  void _deleteBudget(Budget budget) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Budget'),
            content: Text(
              'Are you sure you want to delete the ${budget.category} budget?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _budgets.removeWhere((b) => b.id == budget.id);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class Budget {
  final String id;
  final String category;
  final double amount;
  final double spent;
  final IconData icon;
  final Color color;

  Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.spent,
    required this.icon,
    required this.color,
  });

  Budget copyWith({
    String? id,
    String? category,
    double? amount,
    double? spent,
    IconData? icon,
    Color? color,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      spent: spent ?? this.spent,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}

class _AddBudgetDialog extends StatefulWidget {
  final Function(Budget) onBudgetAdded;

  const _AddBudgetDialog({required this.onBudgetAdded});

  @override
  State<_AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<_AddBudgetDialog> {
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
              value: _selectedCategory,
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

class _EditBudgetDialog extends StatefulWidget {
  final Budget budget;
  final Function(Budget) onBudgetUpdated;

  const _EditBudgetDialog({
    required this.budget,
    required this.onBudgetUpdated,
  });

  @override
  State<_EditBudgetDialog> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<_EditBudgetDialog> {
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

class BudgetCategory {
  final String name;
  final IconData icon;
  final Color color;

  BudgetCategory(this.name, this.icon, this.color);
}
