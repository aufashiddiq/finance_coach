import 'package:finance_coach/data/models/budget_model.dart';
import 'package:finance_coach/presentation/common_widgets/budget_card.dart';
import 'package:finance_coach/presentation/screens/budget/widgets/add_budget_dialog.dart';
import 'package:finance_coach/presentation/screens/budget/widgets/edit_budget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

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
          _buildHeader(context),

          // Budget categories list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _budgets.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: BudgetCard(
                    budget: _budgets[index],
                    onEdit: () => _editBudget(_budgets[index]),
                    onDelete: () => _deleteBudget(_budgets[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
            child: _buildDropdownMonthYear(context),
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
                remainingBudget >= 0 ? Colors.green[300]! : Colors.red[300]!,
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
                  color: totalSpent > totalBudget ? Colors.red : Colors.white,
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
    );
  }

  Widget _buildDropdownMonthYear(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedPeriod,
        dropdownColor: Theme.of(context).primaryColor,
        style: const TextStyle(color: Colors.white),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items:
            ['April 2025', 'May 2025', 'June 2025']
                .map(
                  (period) =>
                      DropdownMenuItem(value: period, child: Text(period)),
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

  void _showAddBudgetDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AddBudgetDialog(
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
          (context) => EditBudgetDialog(
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
