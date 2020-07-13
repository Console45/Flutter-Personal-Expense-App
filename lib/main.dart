import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  // const List<DeviceOrientation> fixedOrientations = [
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp
  // ];
  // WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations(fixedOrientations);
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
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((txn) =>
            txn.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction({
    @required String title,
    @required double amount,
    @required DateTime chosenDate,
  }) {
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
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final pageTitle = Container(
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
        ));

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: pageTitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => startAddNewTxn(context),
                  child: Icon(CupertinoIcons.add),
                )
              ],
            ),
          )
        : AppBar(
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
            title: pageTitle);

    final Widget txnListWidget = (Column(
      children: <Widget>[
        _userTransactions.isNotEmpty
            ? Container(
                margin: EdgeInsets.fromLTRB(25, 0, 0, 10),
                child: Text(
                  'Transactions',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : SizedBox(),
        Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.65,
          child: TransactionList(_userTransactions, _deletTransaction),
        ),
      ],
    ));

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Show Chart',
                      style: TextStyle(fontSize: 15),
                    ),
                    Switch.adaptive(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      },
                    )
                  ],
                ),
              if (isLandscape)
                _showChart
                    ? Container(
                        height: (mediaQuery.size.height -
                                appBar.preferredSize.height -
                                mediaQuery.padding.top) *
                            .7,
                        child: Chart(_recentTransactions),
                      )
                    : txnListWidget,

              if (!isLandscape)
                Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.35,
                  child: Chart(_recentTransactions),
                ),
              if (!isLandscape)
                txnListWidget,

              // if(!isLandscape)
            ],
          ),
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            backgroundColor: Hexcolor('#ffffff'),
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            backgroundColor: Hexcolor('#ffffff'),
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => startAddNewTxn(context),
                  ),
          );
  }
}
