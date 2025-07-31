import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  // Example data - in a real app, this would come from your data layer
  final List<CategoryBudget> _categories = [
    CategoryBudget('Housing', 1200, 900, Icons.home),
    CategoryBudget('Food', 500, 450, Icons.restaurant),
    CategoryBudget(
      'Transport',
      300,
      320,
      Icons.directions_car,
      isOverBudget: true,
    ),
    CategoryBudget('Entertainment', 200, 150, Icons.movie),
    CategoryBudget('Shopping', 300, 280, Icons.shopping_bag),
    CategoryBudget('Healthcare', 150, 100, Icons.medical_services),
  ];

  DateTime _selectedMonth = DateTime.now();
  bool _isExpanded = false;
  int _selectedTab = 0;

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final totalBudget = _categories.fold(
      0.0,
      (sum, category) => sum + category.budget,
    );
    final totalSpent = _categories.fold(
      0.0,
      (sum, category) => sum + category.spent,
    );
    final remainingBudget = totalBudget - totalSpent;
    final percentUsed = totalBudget > 0 ? totalSpent / totalBudget : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Budget',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add budget category screen
              _showAddCategoryDialog();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _showMonthPicker();
                  },
                  child: Row(
                    children: [
                      Text(
                        '${_months[_selectedMonth.month - 1]} ${_selectedMonth.year}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? 280 : 180,
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary
                    Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 12.0,
                          percent: percentUsed.clamp(0.0, 1.0),
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(percentUsed * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const Text(
                                'Used',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          progressColor:
                              percentUsed < 0.75
                                  ? Colors.green
                                  : percentUsed < 0.9
                                  ? Colors.orange
                                  : Colors.red,
                          backgroundColor: Colors.grey[200]!,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Budget: \$${totalBudget.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Spent: \$${totalSpent.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      totalSpent > totalBudget
                                          ? Colors.red
                                          : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Remaining: \$${remainingBudget.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      remainingBudget < 0
                                          ? Colors.red
                                          : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Expanded chart section
                    if (_isExpanded) ...[
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text(
                        'Spending Breakdown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY:
                                _categories.fold(
                                  0.0,
                                  (max, category) =>
                                      category.budget > max
                                          ? category.budget
                                          : max,
                                ) *
                                1.2,
                            barGroups:
                                _categories.asMap().entries.map((entry) {
                                  int idx = entry.key;
                                  CategoryBudget category = entry.value;
                                  return BarChartGroupData(
                                    x: idx,
                                    barRods: [
                                      BarChartRodData(
                                        toY: category.budget,
                                        color: Colors.blue.withOpacity(0.7),
                                        width: 12,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                      BarChartRodData(
                                        toY: category.spent,
                                        color:
                                            category.spent > category.budget
                                                ? Colors.red
                                                : Colors.green,
                                        width: 12,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value >= 0 &&
                                        value < _categories.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Icon(
                                          _categories[value.toInt()].icon,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Tab selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildTabButton('Categories', 0),
                const SizedBox(width: 16),
                _buildTabButton('Transactions', 1),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child:
                _selectedTab == 0
                    ? _buildCategoriesTab()
                    : _buildTransactionsTab(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add transaction
          _showAddTransactionDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color:
                    isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        final percentUsed =
            category.budget > 0 ? category.spent / category.budget : 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          category.icon,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditCategoryDialog(category, index);
                        } else if (value == 'delete') {
                          _showDeleteConfirmationDialog(index);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${category.spent.toStringAsFixed(0)} / \$${category.budget.toStringAsFixed(0)}',
                      style: TextStyle(
                        color:
                            category.isOverBudget ? Colors.red : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${(percentUsed * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color:
                            category.isOverBudget ? Colors.red : Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  percent: percentUsed / 100,
                  lineHeight: 8.0,
                  backgroundColor: Colors.grey[200],
                  progressColor:
                      percentUsed < 0.75
                          ? Colors.green
                          : percentUsed < 0.9
                          ? Colors.orange
                          : Colors.red,
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                ),
                if (category.isOverBudget) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '⚠️ Over budget',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionsTab() {
    // Example transaction data
    final transactions = [
      Transaction('Grocery Shopping', 'Food', 87.35, DateTime.now()),
      Transaction(
        'Electric Bill',
        'Housing',
        120.50,
        DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        'Movie Tickets',
        'Entertainment',
        32.00,
        DateTime.now().subtract(const Duration(days: 3)),
      ),
      Transaction(
        'Gas Station',
        'Transport',
        45.75,
        DateTime.now().subtract(const Duration(days: 4)),
      ),
      Transaction(
        'Online Shopping',
        'Shopping',
        67.99,
        DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              transaction.description,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              '${transaction.category} • ${DateFormat('MMM d').format(transaction.date)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            trailing: Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              // Navigate to transaction detail or edit screen
            },
          ),
        );
      },
    );
  }

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Month',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final now = DateTime.now();
                    final month = DateTime(now.year, index + 1);
                    final isSelected =
                        month.month == _selectedMonth.month &&
                        month.year == _selectedMonth.year;

                    return ListTile(
                      title: Text(DateFormat('MMMM yyyy').format(month)),
                      trailing:
                          isSelected
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                      onTap: () {
                        setState(() {
                          _selectedMonth = month;
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddCategoryDialog() {
    // This would be implemented to allow adding a new budget category
    final TextEditingController nameController = TextEditingController();
    final TextEditingController budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Budget Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                decoration: const InputDecoration(
                  labelText: 'Budget Amount',
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to add new category
                if (nameController.text.isNotEmpty &&
                    budgetController.text.isNotEmpty) {
                  setState(() {
                    _categories.add(
                      CategoryBudget(
                        nameController.text,
                        double.parse(budgetController.text),
                        0.0,
                        Icons.category,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('ADD'),
            ),
          ],
        );
      },
    );
  }

  void _showEditCategoryDialog(CategoryBudget category, int index) {
    // This would be implemented to allow editing an existing budget category
    final TextEditingController nameController = TextEditingController(
      text: category.name,
    );
    final TextEditingController budgetController = TextEditingController(
      text: category.budget.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Budget Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: budgetController,
                decoration: const InputDecoration(
                  labelText: 'Budget Amount',
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to update category
                if (nameController.text.isNotEmpty &&
                    budgetController.text.isNotEmpty) {
                  setState(() {
                    _categories[index] = CategoryBudget(
                      nameController.text,
                      double.parse(budgetController.text),
                      category.spent,
                      category.icon,
                      isOverBudget:
                          category.spent > double.parse(budgetController.text),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('UPDATE'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text(
            'Are you sure you want to delete this budget category?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _categories.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  void _showAddTransactionDialog() {
    // This would be implemented to allow adding a new transaction
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    String? selectedCategory =
        _categories.isNotEmpty ? _categories[0].name : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Transaction'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    hint: const Text('Select Category'),
                    items:
                        _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.name,
                            child: Text(category.name),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to add new transaction
                    if (descriptionController.text.isNotEmpty &&
                        amountController.text.isNotEmpty &&
                        selectedCategory != null) {
                      // Here you would add the transaction to your data source
                      // and update the category's spent amount
                      Navigator.of(context).pop();

                      // Show success snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaction added successfully'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('ADD'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// Data models
class CategoryBudget {
  final String name;
  final double budget;
  final double spent;
  final IconData icon;
  final bool isOverBudget;

  CategoryBudget(
    this.name,
    this.budget,
    this.spent,
    this.icon, {
    this.isOverBudget = false,
  });
}

class Transaction {
  final String description;
  final String category;
  final double amount;
  final DateTime date;

  Transaction(this.description, this.category, this.amount, this.date);
}
