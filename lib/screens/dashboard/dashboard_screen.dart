import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../app/routes.dart';
import '../../providers/app_state_provider.dart';
import '../../models/transaction_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final currencyFormat = NumberFormat.currency(symbol: '\$');

  // Mock data
  final List<Transaction> _recentTransactions = [
    Transaction(
      id: '1',
      title: 'Grocery Shopping',
      amount: 85.75,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Groceries',
      isExpense: true,
    ),
    Transaction(
      id: '2',
      title: 'Salary Deposit',
      amount: 2500.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Income',
      isExpense: false,
    ),
    Transaction(
      id: '3',
      title: 'Netflix Subscription',
      amount: 14.99,
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Entertainment',
      isExpense: true,
    ),
    Transaction(
      id: '4',
      title: 'Restaurant Dinner',
      amount: 42.50,
      date: DateTime.now().subtract(const Duration(days: 7)),
      category: 'Food & Dining',
      isExpense: true,
    ),
  ];

  final Map<String, double> _budgetData = {
    'Food & Dining': 500.0,
    'Groceries': 300.0,
    'Entertainment': 150.0,
    'Transportation': 200.0,
    'Shopping': 150.0,
    'Utilities': 200.0,
  };

  final Map<String, double> _spendingData = {
    'Food & Dining': 320.0,
    'Groceries': 250.0,
    'Entertainment': 110.0,
    'Transportation': 120.0,
    'Shopping': 75.0,
    'Utilities': 180.0,
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Implement profile screen
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting
              Text(
                'Hello ${provider.authService.currentUser?.name ?? 'User'}!',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 4.0),

              Text(
                'Here\'s your financial summary',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24.0),

              // Summary cards
              Row(
                children: [
                  _buildSummaryCard(
                    context,
                    'Total Balance',
                    currencyFormat.format(3250.76),
                    Icons.account_balance_wallet,
                    Colors.blue,
                  ),
                  const SizedBox(width: 16.0),
                  _buildSummaryCard(
                    context,
                    'Monthly Savings',
                    currencyFormat.format(850.00),
                    Icons.savings,
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Budget overview
              _buildSectionHeader(context, 'Budget Overview', AppRoutes.budget),
              const SizedBox(height: 16.0),
              _buildBudgetChart(),
              const SizedBox(height: 24.0),

              // Recent transactions
              _buildSectionHeader(context, 'Recent Transactions', null),
              const SizedBox(height: 8.0),
              _buildRecentTransactions(),
              const SizedBox(height: 24.0),

              // Quick actions
              _buildSectionHeader(context, 'Quick Actions', null),
              const SizedBox(height: 8.0),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navigate to different screens based on selection
          switch (index) {
            case 0:
              // Dashboard - Already here
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.budget);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.goals);
              break;
            case 3:
              // TODO: Implement settings screen
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_outlined),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
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
            Row(
              children: [
                Icon(icon, color: color, size: 20.0),
                const SizedBox(width: 8.0),
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              amount,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String? route,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (route != null)
          TextButton(
            onPressed: () => Navigator.pushNamed(context, route),
            child: const Text('View All'),
          ),
      ],
    );
  }

  Widget _buildBudgetChart() {
    final List<String> categories = _budgetData.keys.toList();

    return Container(
      height: 220.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
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
          Text(
            'Top Categories',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 600,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${categories[groupIndex]}\n${currencyFormat.format(rod.toY)}',
                        const TextStyle(color: Colors.black),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= categories.length ||
                            value.toInt() < 0) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            categories[value.toInt()].substring(0, 3),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 200 != 0) {
                          return const SizedBox();
                        }
                        return Text(
                          '\$${value.toInt()}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 200,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: Colors.grey[300], strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  categories.length > 4 ? 4 : categories.length,
                  (index) {
                    final category = categories[index];
                    final budget = _budgetData[category] ?? 0;
                    final spent = _spendingData[category] ?? 0;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: budget,
                          color: Colors.grey[400],
                          width: 14,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: spent,
                          color:
                              spent > budget
                                  ? Colors.red
                                  : Theme.of(context).primaryColor,
                          width: 14,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartLegend(context, 'Budget', Colors.grey[400]!),
              const SizedBox(width: 24.0),
              _buildChartLegend(
                context,
                'Spent',
                Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4.0),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children:
            _recentTransactions.map((transaction) {
              return _buildTransactionItem(transaction);
            }).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color:
              transaction.isExpense
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          transaction.isExpense ? Icons.arrow_upward : Icons.arrow_downward,
          color: transaction.isExpense ? Colors.red : Colors.green,
          size: 20.0,
        ),
      ),
      title: Text(
        transaction.title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        '${transaction.category} • ${DateFormat('MMM d').format(transaction.date)}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Text(
        '${transaction.isExpense ? '-' : '+'} ${currencyFormat.format(transaction.amount)}',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: transaction.isExpense ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          context,
          'Add Income',
          Icons.add_circle_outline,
          Colors.green,
          () {},
        ),
        _buildActionButton(
          context,
          'Add Expense',
          Icons.remove_circle_outline,
          Colors.red,
          () {},
        ),
        _buildActionButton(
          context,
          'Transfer',
          Icons.swap_horiz,
          Colors.blue,
          () {},
        ),
        _buildActionButton(
          context,
          'Scan Receipt',
          Icons.document_scanner_outlined,
          Colors.purple,
          () {},
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28.0),
          ),
          const SizedBox(height: 8.0),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
