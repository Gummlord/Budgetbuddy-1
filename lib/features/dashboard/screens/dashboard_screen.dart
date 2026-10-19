import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../config/theme.dart';
import '../../../models/expense.dart';
import '../../../providers/expense_provider.dart';
import '../../../widgets/app_drawer.dart';

/// Dashboard ported from the `budgetbuddy_dashboard_floatingaction` project.
/// It now reads from the shared [ExpenseProvider] so the numbers stay in sync
/// with the expense/budget features and the global FAB.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const double barRodWidth = 12;
  static const double barRodRadius = 4;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final transactions = context.watch<ExpenseProvider>().expenses;

    final income = transactions.where((t) => t.isIncome).toList();
    final expenses = transactions.where((t) => !t.isIncome).toList();

    final totalExpenses =
        expenses.fold<double>(0, (total, e) => total + e.amount);
    final totalIncome =
        income.fold<double>(0, (total, t) => total + t.amount);

    // Last three calendar days, oldest to newest.
    final days = List.generate(
      3,
      (index) => DateTime.now().subtract(Duration(days: 2 - index)),
    );
    final dayLabels = days.map((d) => DateFormat('EEE').format(d)).toList();

    double getDailyTotal(List<Expense> items, DateTime day) {
      return items
          .where((t) =>
              t.date.year == day.year &&
              t.date.month == day.month &&
              t.date.day == day.day)
          .fold<double>(0, (total, t) => total + t.amount);
    }

    final dailyExpenseTotals =
        days.map((d) => getDailyTotal(expenses, d)).toList();
    final dailyIncomeTotals =
        days.map((d) => getDailyTotal(income, d)).toList();

    double highestDailyTotal = 0;
    for (int i = 0; i < days.length; i++) {
      if (dailyExpenseTotals[i] > highestDailyTotal) {
        highestDailyTotal = dailyExpenseTotals[i];
      }
      if (dailyIncomeTotals[i] > highestDailyTotal) {
        highestDailyTotal = dailyIncomeTotals[i];
      }
    }
    final chartMaxY =
        highestDailyTotal == 0 ? 700.0 : highestDailyTotal * 1.2;

    final Map<String, double> categoryTotals = {};
    for (final expense in expenses) {
      categoryTotals.update(
        expense.category,
        (amount) => amount + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    final categoryEntries = categoryTotals.entries.toList();
    final categoryColors = c.chartPalette;

    final currency = NumberFormat.currency(
      locale: 'en_PH',
      symbol: '₱',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text('Budget Buddy'),
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => rootScaffoldKey.currentState?.openDrawer(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        elevation: 8,
        shadowColor: c.shadow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('Dashboard',
                        style: AppTextStyles.subHeader
                            .copyWith(color: c.textPrimary)),
                  ),

                  // BALANCE CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: c.banner,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance',
                          style: TextStyle(fontSize: 28, color: c.onBanner),
                        ),
                        const SizedBox(height: 10),
                        Divider(
                            color: c.onBannerMuted, thickness: 1, height: 20),
                        const SizedBox(height: 10),
                        Text(
                          (income.isEmpty && expenses.isEmpty)
                              ? '₱0.00'
                              : currency.format(totalIncome - totalExpenses),
                          style:
                              AppTextStyles.title.copyWith(color: c.onBanner),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // EXPENSE AND INCOME CARDS
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Expense',
                          icon: Icons.trending_down,
                          color: c.expense,
                          amount: expenses.isEmpty
                              ? '₱0.00'
                              : currency.format(totalExpenses),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Income',
                          icon: Icons.trending_up,
                          color: c.income,
                          amount: income.isEmpty
                              ? '₱0.00'
                              : currency.format(totalIncome),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ALL-TIME EXPENSES PIE CHART
                  Text('All Time Expenses',
                      style: AppTextStyles.subHeader
                          .copyWith(color: c.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.banner,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: categoryEntries.isEmpty
                                ? Center(
                                    child: Text(
                                      'No data',
                                      style: TextStyle(color: c.onBanner),
                                    ),
                                  )
                                : PieChart(
                                    PieChartData(
                                      sectionsSpace: 3,
                                      centerSpaceRadius: 0,
                                      sections: [
                                        for (int i = 0;
                                            i < categoryEntries.length;
                                            i++)
                                          PieChartSectionData(
                                            value: categoryEntries[i].value,
                                            title: '',
                                            color: categoryColors[
                                                i % categoryColors.length],
                                            radius: 75,
                                          ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(
                                  color: c.onBanner,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (categoryEntries.isEmpty)
                                Text(
                                  'No expenses yet',
                                  style: TextStyle(color: c.onBanner),
                                ),
                              for (int i = 0; i < categoryEntries.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        margin: const EdgeInsets.only(top: 4),
                                        decoration: BoxDecoration(
                                          color: categoryColors[
                                              i % categoryColors.length],
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              categoryEntries[i].key,
                                              style: TextStyle(
                                                color: c.onBanner,
                                                fontSize: 11,
                                              ),
                                            ),
                                            Text(
                                              '₱${categoryEntries[i].value.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: c.onBannerMuted,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // INCOME AND EXPENSE BAR CHART
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('Income/Expense Overview',
                        style: AppTextStyles.subHeader
                            .copyWith(color: c.textPrimary)),
                  ),
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: c.banner,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _legendDot(context, c.expense, 'Expense'),
                              const SizedBox(width: 20),
                              _legendDot(context, c.income, 'Income'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: BarChart(
                              BarChartData(
                                maxY: chartMaxY,
                                groupsSpace: 8,
                                rotationQuarterTurns: 1,
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 35,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index < 0 ||
                                            index >= dayLabels.length) {
                                          return const SizedBox.shrink();
                                        }
                                        return SideTitleWidget(
                                          meta: meta,
                                          child: Text(
                                            dayLabels[index],
                                            style: AppTextStyles.chartTextStyle
                                                .copyWith(
                                                    color: c.onBanner),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                      getTitlesWidget: (value, meta) {
                                        return Text(
                                          NumberFormat.compact().format(value),
                                          style: AppTextStyles.chartTextStyle
                                              .copyWith(color: c.onBanner),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                barGroups: [
                                  for (int i = 0; i < days.length; i++)
                                    BarChartGroupData(
                                      x: i,
                                      barRods: [
                                        BarChartRodData(
                                          toY: dailyExpenseTotals[i],
                                          width: barRodWidth,
                                          borderRadius: BorderRadius.circular(
                                              barRodRadius),
                                          color: c.expense,
                                        ),
                                        BarChartRodData(
                                          toY: dailyIncomeTotals[i],
                                          width: barRodWidth,
                                          borderRadius: BorderRadius.circular(
                                              barRodRadius),
                                          color: c.income,
                                        ),
                                      ],
                                    ),
                                ],
                                borderData: FlBorderData(show: false),
                                gridData: const FlGridData(show: true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendDot(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.chartTextStyle
              .copyWith(color: context.colors.onBanner),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.amount,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: c.onBanner, size: 26),
                const SizedBox(width: 8),
                Text(title,
                    style: AppTextStyles.title.copyWith(color: c.onBanner)),
              ],
            ),
            Divider(color: c.onBanner, thickness: 1, height: 20),
            Text(amount,
                style: AppTextStyles.title.copyWith(color: c.onBanner)),
          ],
        ),
      ),
    );
  }
}
