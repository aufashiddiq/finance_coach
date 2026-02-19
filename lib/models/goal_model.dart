import 'package:flutter/material.dart';

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

class GoalTemplate {
  final String name;
  final IconData icon;
  final Color color;

  GoalTemplate(this.name, this.icon, this.color);
}
