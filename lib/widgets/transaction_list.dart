import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTxn;

  TransactionList(this.transactions, this.deleteTxn);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 450,
        child: transactions.isEmpty
            ? Column(
                children: <Widget>[
                  Text(
                    "No Transactions",
                    style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: Hexcolor('#272736'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: .4,
                          color: Hexcolor('#cccccc'),
                        ),
                      ),
                      child: Dismissible(
                        key: ValueKey(transactions[index].id),
                        onDismissed: (direction) {
                          deleteTxn(transactions[index].id);
                        },
                        background: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Icon(Icons.delete, color: Colors.white),
                            ],
                          ),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      transactions[index].title,
                                      style: GoogleFonts.robotoCondensed(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Hexcolor('#000000'),
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMEd()
                                          .format(transactions[index].date),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Hexcolor('#BCBCC1'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Text(
                                  '\$${transactions[index].amount.toStringAsFixed(2)}',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Hexcolor('#000000'),
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
                itemCount: transactions.length,
              ));
  }
}
