import 'package:finance_coach/models/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LargeGoalCard extends StatelessWidget {
  final FinancialGoal goal;
  final VoidCallback? onShowOptions;
  final VoidCallback? onAddContribution;
  final VoidCallback? onViewDetails;
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  LargeGoalCard({
    super.key,
    required this.goal,
    this.onShowOptions,
    this.onAddContribution,
    this.onViewDetails,
  });

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
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
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

  @override
  Widget build(BuildContext context) {
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
            color: Colors.black.withValues(alpha: 0.05),
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
                  color: goal.color.withValues(alpha: 0.1),
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
                        Expanded(
                          child: Text(
                            goal.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
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
                onPressed: onShowOptions,
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
                    colors: [goal.color, goal.color.withValues(alpha: 0.7)],
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
                  onPressed: onAddContribution,
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
                  onPressed: onViewDetails,
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
}
