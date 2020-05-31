import 'package:dailybudgetapp/data/db_helper.dart';
import 'package:dailybudgetapp/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetHomeScreen extends StatefulWidget {
  @override
  _BudgetHomeScreenState createState() => _BudgetHomeScreenState();
}

class _BudgetHomeScreenState extends State<BudgetHomeScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  int id;
  String _description;
  double _amount;
  int currentId;
  String _type = "Expense";

  final formKey = new GlobalKey<FormState>();
  Future<List<Transactions>> transactions;
  DatabaseHelper dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    isUpdating = false;
    dbHelper = DatabaseHelper();
  }

  refreshTransaction() {
    setState(() {
      transactions = dbHelper.getTransaction();
    });
  } 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Budget Manager"),
         actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: null), //() => _startAddNewTransaction(context)),
        ], 
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: formKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter description.';
                      }
                      if (value.trim() == "") return "Invalid entry.";
                      return null;
                    },
                    onSaved: (value) {
                      _description = value;
                    },
                    controller: descriptionController,
                    decoration: InputDecoration(
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.green,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                      labelText: "Description",
                      icon: Icon(
                        Icons.description,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter amount.';
                      }
                      if (value.trim() == "") return "Invalid entry.";
                      return null;
                    },
                    onSaved: (value) {
                      _amount = double.parse(value);
                    },
                    controller: amountController,
                    decoration: InputDecoration(
                      focusedBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.green,
                            width: 1,
                            style: BorderStyle.solid),
                      ),
                      labelText: "Amount",
                      icon: Icon(
                        Icons.money_off,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                  color: Colors.grey,
                  child: Text(
                    isUpdating ? 'Update' : 'Add',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (isUpdating) {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        dbHelper
                            .updateTransaction(Transactions(
                                currentId, _description, _amount, _type))
                            .then((data) {
                          setState(() {
                            isUpdating = false;
                          });
                        });
                      }
                    } else {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        dbHelper.saveTransaction(
                            Transactions(null, _description, _amount, _type));
                      }
                    }
                    descriptionController.text = "";
                    amountController.text = "";
                    refreshTransaction();
                  }),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              RaisedButton(
                color: Colors.red,
                child: Text(
                  (isUpdating ? 'Cancel Update' : 'Clear'),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  descriptionController.text = '';
                  amountController.text = '0.00';
                  setState(() {
                    isUpdating = false;
                    currentId = null;
                    print('Cleared..');
                  });
                },
              ),
            ],
          ),
          const Divider(
            height: 2.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: transactions,
              builder: (BuildContext context,AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return generateList(snapshot.data);
                }
                if (snapshot.data == null) {
                  return Text('No Data Found.');
                } 
                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView generateList(List<Transactions> transaction) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical ,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Description'),
            ),
            DataColumn(
              label: Text('Amount'),
            ), 
            DataColumn(
              label: Text('Action'),
            )
          ],
          rows: transaction
              .map(
                (transaction) => DataRow(
                  cells: [
                    DataCell(
                      Text(transaction.transactionName),
                      onTap: () {
                        setState(() {
                          isUpdating = true;
                          currentId = transaction.id;
                        });
                        descriptionController.text =
                            transaction.transactionName;
                        amountController.text =
                            transaction.amount.toStringAsFixed(2);
                      },
                    ),
                    DataCell(
                      Text( transaction.amount.toStringAsFixed(2)),
                      onTap: () {
                        setState(() {
                          isUpdating = true;
                          currentId = transaction.id;
                        });
                         descriptionController.text =
                            transaction.transactionName;
                        amountController.text = transaction.amount.toStringAsFixed(2);
                      },
                    ), 
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          dbHelper.deleteTransaction(transaction.id);
                          refreshTransaction();
                        },
                      ),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
} //end main class
