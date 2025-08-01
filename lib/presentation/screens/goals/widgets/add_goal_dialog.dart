import 'package:finance_coach/data/models/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddGoalDialog extends StatefulWidget {
  final Function(FinancialGoal) onGoalAdded;

  const AddGoalDialog({super.key, required this.onGoalAdded});

  @override
  State<AddGoalDialog> createState() => AddGoalDialogState();
}

class AddGoalDialogState extends State<AddGoalDialog> {
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
