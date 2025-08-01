import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SmallGoalCard extends StatelessWidget {
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const SmallGoalCard({
    super.key,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final progress = (currentAmount / targetAmount).clamp(0.0, 1.0);
    final remaining = targetAmount - currentAmount;
    final daysUntilDeadline = deadline.difference(DateTime.now()).inDays;

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 24.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Target: ${currencyFormat.format(targetAmount)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    currencyFormat.format(currentAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
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
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}% complete',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14.0,
                        color:
                            daysUntilDeadline < 30
                                ? Colors.red
                                : Colors.grey[600],
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        daysUntilDeadline > 0
                            ? '$daysUntilDeadline days'
                            : 'Overdue',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              daysUntilDeadline < 30
                                  ? Colors.red
                                  : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
