import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BarChart extends StatelessWidget {
  final String label;
  final double amount;
  final double totalPercentage;
  BarChart(this.label, this.amount, this.totalPercentage);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.09,
            child: FittedBox(
              child: Text(
                '${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.08,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 6,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: totalPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: label == "Tu" || label == 'Su' || label == 'Fr'
                          ? Hexcolor('#4EEAFD')
                          : Hexcolor('#FC8F84'),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.08,
          ),
          Container(
            height: constraints.maxHeight * 0.09,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
