import 'package:flutter/material.dart';

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

class BudgetCategory {
  final String name;
  final IconData icon;
  final Color color;

  BudgetCategory(this.name, this.icon, this.color);
}
