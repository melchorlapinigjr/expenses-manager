import 'package:flutter/material.dart';
import 'package:dailybudgetapp/data/db_helper.dart';  
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addHandler;
  NewTransaction(this.addHandler);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final descriptionController = TextEditingController();
  final amountController = TextEditingController(); 
   DateTime _selectedDate;
   
    void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }
   
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Decoration'),
              controller: descriptionController,
              onSubmitted: (_) => null,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => print('save'),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen'
                          : DateFormat.yMd().format(_selectedDate),
                    ),
                  ),
                  FlatButton(
                    child: Text('Choose Date'),
                    onPressed: _presentDatePicker,
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
            FlatButton(
                child: Text('Add Transaction'),
                textColor: Colors.blueAccent,
                onPressed: () => null())
          ],
        ),
      ),
    );
  }
}