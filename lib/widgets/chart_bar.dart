import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BarChart extends StatelessWidget {
  final String label;
  final double amount;
  final double totalPercentage;
  BarChart(this.label, this.amount, this.totalPercentage);

  @override
  Widget build(BuildContext context) {
    print(label.runtimeType);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(
          height: 17,
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
          height: 20,
        ),
        Container(
          height: 100,
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
          height: 18,
        ),
        Text(label),
      ],
    );
  }
}
