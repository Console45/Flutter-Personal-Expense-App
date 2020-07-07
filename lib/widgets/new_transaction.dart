import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;
  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitTransaction() {
    final String enteredTitle = _titleController.text;
    final String enteredAmount = _amountController.text;

    if (enteredTitle.isEmpty ||
        enteredAmount.isEmpty ||
        double.parse(enteredAmount) <= 0 ||
        _selectedDate == null) return;
    widget.addNewTransaction(
      title: enteredTitle,
      amount: double.parse(enteredAmount),
      chosenDate: _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _showDatePicker() async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) return;
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: _titleController,
            onSubmitted: (_) => _submitTransaction(),
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            controller: _amountController,
            onSubmitted: (_) => _submitTransaction(),
          ),
          Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _selectedDate == null
                      ? 'No Date Chosen'
                      : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                ),
                FlatButton(
                  onPressed: _showDatePicker,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
          RaisedButton(
            onPressed: _submitTransaction,
            child: Text("Add Transaction"),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }
}
