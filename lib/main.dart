import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primaryColor: Hexcolor('#6382F5'),
        accentColor: Hexcolor('#6382F5'),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((txn) =>
            txn.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(
      {@required String title,
      @required double amount,
      @required DateTime chosenDate}) {
    final newTransaction = Transaction(
        title: title,
        amount: amount,
        date: chosenDate,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _deletTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((txn) => txn.id == id);
    });
  }

  void startAddNewTxn(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 30),
            onPressed: () => startAddNewTxn(context),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
        backgroundColor: Hexcolor('#ffffff'),
        elevation: 0,
        title: Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Personal Expenses",
                  style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Hexcolor('#272736'),
                  )),
                ),
                Text(
                  'My daily personal Expenses',
                  style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(
                    color: Hexcolor('#BCBCC1'),
                    fontSize: 12,
                  )),
                )
              ],
            )),
      ),
      backgroundColor: Hexcolor('#ffffff'),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Chart(_recentTransactions),
              _userTransactions.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.fromLTRB(25, 0, 0, 10),
                      child: Text(
                        'Transactions',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : SizedBox(),
              TransactionList(_userTransactions, _deletTransaction),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTxn(context),
      ),
    );
  }
}
