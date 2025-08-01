import 'package:finance_coach/data/models/goal_model.dart';
import 'package:finance_coach/presentation/common_widgets/large_goal_card.dart';
import 'package:finance_coach/presentation/screens/goals/widgets/add_contribution_dialog.dart';
import 'package:finance_coach/presentation/screens/goals/widgets/add_goal_dialog.dart';
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
                  child: LargeGoalCard(
                    goal: sortedGoals[index],
                    onViewDetails: () => _viewGoalDetails(sortedGoals[index]),
                    onAddContribution:
                        () => _addContribution(sortedGoals[index]),
                    onShowOptions: () => _showGoalOptions(sortedGoals[index]),
                  ),
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

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AddGoalDialog(
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
          (context) => AddContributionDialog(
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
