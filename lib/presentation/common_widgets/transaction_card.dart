import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final IconData? icon;
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16.0),
        leading: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color:
                isExpense
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon ?? (isExpense ? Icons.remove : Icons.add),
            color: isExpense ? Colors.red : Colors.green,
            size: 20.0,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '$category • ${DateFormat('MMM d, yyyy').format(date)}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        trailing: Text(
          '${isExpense ? '-' : '+'} ${currencyFormat.format(amount)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
