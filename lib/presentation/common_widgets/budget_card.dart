import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetCard extends StatelessWidget {
  final String category;
  final double budgetAmount;
  final double spentAmount;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const BudgetCard({
    Key? key,
    required this.category,
    required this.budgetAmount,
    required this.spentAmount,
    required this.color,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final progress = (spentAmount / budgetAmount).clamp(0.0, 1.0);
    final remaining = budgetAmount - spentAmount;
    final isOverBudget = spentAmount > budgetAmount;

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
                          category,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isOverBudget
                              ? 'Over by ${currencyFormat.format(spentAmount - budgetAmount)}'
                              : '${currencyFormat.format(remaining)} remaining',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: isOverBudget ? Colors.red : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    currencyFormat.format(spentAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isOverBudget ? Colors.red : null,
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
                      color: isOverBudget ? Colors.red : color,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toStringAsFixed(1)}% used',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  Text(
                    'of ${currencyFormat.format(budgetAmount)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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
