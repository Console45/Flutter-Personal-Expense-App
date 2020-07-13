import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (int i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year)
          totalSum += recentTransaction[i].amount;
      }

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 2),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactions.fold(0.0, (sum, txn) {
      return sum + txn['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: groupedTransactions.map((txnData) {
          return Flexible(
            fit: FlexFit.tight,
            child: BarChart(
                txnData['day'],
                txnData['amount'],
                totalSpending == 0.0
                    ? 0.0
                    : (txnData['amount'] as double) / totalSpending),
          );
        }).toList(),
      ),
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    );
  }
}
