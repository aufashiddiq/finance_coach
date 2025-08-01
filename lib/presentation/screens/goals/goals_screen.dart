import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  // Mock data
  final List<FinancialGoal> _goals = [
    FinancialGoal(
      id: '1',
      name: 'Emergency Fund',
      targetAmount: 10000.0,
      currentAmount: 6500.0,
      deadline: DateTime(2025, 12, 31),
      icon: Icons.security,
      color: Colors.green,
      priority: GoalPriority.high,
    ),
    FinancialGoal(
      id: '2',
      name: 'Vacation to Europe',
      targetAmount: 5000.0,
      currentAmount: 2800.0,
      deadline: DateTime(2025, 8, 15),
      icon: Icons.flight,
      color: Colors.blue,
      priority: GoalPriority.medium,
    ),
    FinancialGoal(
      id: '3',
      name: 'New Car',
      targetAmount: 25000.0,
      currentAmount: 8500.0,
      deadline: DateTime(2026, 6, 30),
      icon: Icons.directions_car,
      color: Colors.orange,
      priority: GoalPriority.medium,
    ),
    FinancialGoal(
      id: '4',
      name: 'House Down Payment',
      targetAmount: 50000.0,
      currentAmount: 15000.0,
      deadline: DateTime(2027, 3, 31),
      icon: Icons.home,
      color: Colors.purple,
      priority: GoalPriority.high,
    ),
    FinancialGoal(
      id: '5',
      name: 'Wedding Fund',
      targetAmount: 15000.0,
      currentAmount: 4200.0,
      deadline: DateTime(2026, 9, 15),
      icon: Icons.favorite,
      color: Colors.pink,
      priority: GoalPriority.low,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Sort goals by priority and progress
    final sortedGoals = List<FinancialGoal>.from(_goals);
    sortedGoals.sort((a, b) {
      // First by priority
      final priorityComparison = a.priority.index.compareTo(b.priority.index);
      if (priorityComparison != 0) return priorityComparison;

      // Then by progress percentage (descending)
      final aProgress = a.currentAmount / a.targetAmount;
      final bProgress = b.currentAmount / b.targetAmount;
      return bProgress.compareTo(aProgress);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddGoalDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Goals summary
          Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem(
                      'Total Goals',
                      _goals.length.toString(),
                      Colors.white,
                    ),
                    _buildSummaryItem(
                      'Total Target',
                      currencyFormat.format(
                        _goals.fold(
                          0.0,
                          (sum, goal) => sum + goal.targetAmount,
                        ),
                      ),
                      Colors.white,
                    ),
                    _buildSummaryItem(
                      'Total Saved',
                      currencyFormat.format(
                        _goals.fold(
                          0.0,
                          (sum, goal) => sum + goal.currentAmount,
                        ),
                      ),
                      Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Overall progress
                Container(
                  width: double.infinity,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _getOverallProgress(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),

                Text(
                  '${(_getOverallProgress() * 100).toStringAsFixed(1)}% overall progress',
                  style: const TextStyle(color: Colors.white70, fontSize: 14.0),
                ),
              ],
            ),
          ),

          // Goals list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: sortedGoals.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildGoalCard(sortedGoals[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14.0),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double _getOverallProgress() {
    final totalTarget = _goals.fold(
      0.0,
      (sum, goal) => sum + goal.targetAmount,
    );
    final totalCurrent = _goals.fold(
      0.0,
      (sum, goal) => sum + goal.currentAmount,
    );
    return totalTarget > 0 ? (totalCurrent / totalTarget).clamp(0.0, 1.0) : 0.0;
  }

  Widget _buildGoalCard(FinancialGoal goal) {
    final double progress = (goal.currentAmount / goal.targetAmount).clamp(
      0.0,
      1.0,
    );
    final double remaining = goal.targetAmount - goal.currentAmount;
    final int daysUntilDeadline =
        goal.deadline.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.0),
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
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: goal.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(goal.icon, color: goal.color, size: 28.0),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          goal.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8.0),
                        _buildPriorityChip(goal.priority),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Target: ${currencyFormat.format(goal.targetAmount)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showGoalOptions(goal),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // Progress section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    currencyFormat.format(goal.currentAmount),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: goal.color,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Remaining',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    currencyFormat.format(remaining),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Progress bar
          Container(
            width: double.infinity,
            height: 12.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [goal.color, goal.color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Progress percentage and deadline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(1)}% complete',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16.0,
                    color:
                        daysUntilDeadline < 30 ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    daysUntilDeadline > 0
                        ? '$daysUntilDeadline days left'
                        : 'Overdue',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          daysUntilDeadline < 30
                              ? Colors.red
                              : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addContribution(goal),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Money'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: goal.color,
                    side: BorderSide(color: goal.color),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _viewGoalDetails(goal),
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goal.color,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(GoalPriority priority) {
    Color chipColor;
    String label;

    switch (priority) {
      case GoalPriority.high:
        chipColor = Colors.red;
        label = 'High';
        break;
      case GoalPriority.medium:
        chipColor = Colors.orange;
        label = 'Medium';
        break;
      case GoalPriority.low:
        chipColor = Colors.green;
        label = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: chipColor,
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder:
          (context) => _AddGoalDialog(
            onGoalAdded: (goal) {
              setState(() {
                _goals.add(goal);
              });
            },
          ),
    );
  }

  void _showGoalOptions(FinancialGoal goal) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Goal'),
                  onTap: () {
                    Navigator.pop(context);
                    _editGoal(goal);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle_outline),
                  title: const Text('Add Contribution'),
                  onTap: () {
                    Navigator.pop(context);
                    _addContribution(goal);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('View History'),
                  onTap: () {
                    Navigator.pop(context);
                    _viewGoalHistory(goal);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete Goal',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteGoal(goal);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _addContribution(FinancialGoal goal) {
    showDialog(
      context: context,
      builder:
          (context) => _AddContributionDialog(
            goal: goal,
            onContributionAdded: (amount) {
              setState(() {
                final index = _goals.indexWhere((g) => g.id == goal.id);
                if (index != -1) {
                  _goals[index] = goal.copyWith(
                    currentAmount: goal.currentAmount + amount,
                  );
                }
              });
            },
          ),
    );
  }

  void _viewGoalDetails(FinancialGoal goal) {
    // Navigate to goal details screen (to be implemented)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Goal details for ${goal.name}')));
  }

  void _editGoal(FinancialGoal goal) {
    // Show edit goal dialog (to be implemented)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${goal.name}')));
  }

  void _viewGoalHistory(FinancialGoal goal) {
    // Show goal history (to be implemented)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('History for ${goal.name}')));
  }

  void _deleteGoal(FinancialGoal goal) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Goal'),
            content: Text(
              'Are you sure you want to delete "${goal.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _goals.removeWhere((g) => g.id == goal.id);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${goal.name} deleted')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

enum GoalPriority { high, medium, low }

class FinancialGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final IconData icon;
  final Color color;
  final GoalPriority priority;

  FinancialGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.icon,
    required this.color,
    required this.priority,
  });

  FinancialGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    IconData? icon,
    Color? color,
    GoalPriority? priority,
  }) {
    return FinancialGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      priority: priority ?? this.priority,
    );
  }
}

class _AddGoalDialog extends StatefulWidget {
  final Function(FinancialGoal) onGoalAdded;

  const _AddGoalDialog({required this.onGoalAdded});

  @override
  State<_AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<_AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();

  DateTime _selectedDeadline = DateTime.now().add(const Duration(days: 365));
  GoalPriority _selectedPriority = GoalPriority.medium;
  IconData _selectedIcon = Icons.flag;
  Color _selectedColor = Colors.blue;

  final List<GoalTemplate> _templates = [
    GoalTemplate('Emergency Fund', Icons.security, Colors.green),
    GoalTemplate('Vacation', Icons.flight, Colors.blue),
    GoalTemplate('New Car', Icons.directions_car, Colors.orange),
    GoalTemplate('House Down Payment', Icons.home, Colors.purple),
    GoalTemplate('Wedding', Icons.favorite, Colors.pink),
    GoalTemplate('Education', Icons.school, Colors.indigo),
    GoalTemplate('Retirement', Icons.elderly, Colors.brown),
    GoalTemplate('Investment', Icons.trending_up, Colors.teal),
    GoalTemplate('Debt Payoff', Icons.money_off, Colors.red),
    GoalTemplate('Other', Icons.flag, Colors.grey),
  ];

  GoalTemplate? _selectedTemplate;

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Goal'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Template selection
                DropdownButtonFormField<GoalTemplate>(
                  value: _selectedTemplate,
                  decoration: const InputDecoration(
                    labelText: 'Goal Type',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      _templates.map((template) {
                        return DropdownMenuItem(
                          value: template,
                          child: Row(
                            children: [
                              Icon(
                                template.icon,
                                color: template.color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(template.name),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTemplate = value;
                      if (value != null) {
                        _nameController.text = value.name;
                        _selectedIcon = value.icon;
                        _selectedColor = value.color;
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Goal name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a goal name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Target amount
                TextFormField(
                  controller: _targetAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Target Amount',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter target amount';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Current amount
                TextFormField(
                  controller: _currentAmountController,
                  decoration: const InputDecoration(
                    labelText: 'Current Amount (Optional)',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (double.tryParse(value) == null ||
                          double.parse(value) < 0) {
                        return 'Please enter a valid amount';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Priority selection
                DropdownButtonFormField<GoalPriority>(
                  value: _selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      GoalPriority.values.map((priority) {
                        String label;
                        Color color;
                        switch (priority) {
                          case GoalPriority.high:
                            label = 'High Priority';
                            color = Colors.red;
                            break;
                          case GoalPriority.medium:
                            label = 'Medium Priority';
                            color = Colors.orange;
                            break;
                          case GoalPriority.low:
                            label = 'Low Priority';
                            color = Colors.green;
                            break;
                        }
                        return DropdownMenuItem(
                          value: priority,
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(label),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Deadline selection
                InkWell(
                  onTap: _selectDeadline,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Target Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      DateFormat('MMM dd, yyyy').format(_selectedDeadline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _saveGoal, child: const Text('Add Goal')),
      ],
    );
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // 10 years
    );
    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _saveGoal() {
    if (_formKey.currentState?.validate() ?? false) {
      final goal = FinancialGoal(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        targetAmount: double.parse(_targetAmountController.text),
        currentAmount:
            _currentAmountController.text.isEmpty
                ? 0.0
                : double.parse(_currentAmountController.text),
        deadline: _selectedDeadline,
        icon: _selectedIcon,
        color: _selectedColor,
        priority: _selectedPriority,
      );

      widget.onGoalAdded(goal);
      Navigator.pop(context);
    }
  }
}

class _AddContributionDialog extends StatefulWidget {
  final FinancialGoal goal;
  final Function(double) onContributionAdded;

  const _AddContributionDialog({
    required this.goal,
    required this.onContributionAdded,
  });

  @override
  State<_AddContributionDialog> createState() => _AddContributionDialogState();
}

class _AddContributionDialogState extends State<_AddContributionDialog> {
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

class GoalTemplate {
  final String name;
  final IconData icon;
  final Color color;

  GoalTemplate(this.name, this.icon, this.color);
}
