import 'package:flutter/material.dart';

class TypeExpensesScreen extends StatefulWidget {
  @override
  _TypeExpensesScreenState createState() => _TypeExpensesScreenState();
}

class _TypeExpensesScreenState extends State<TypeExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Type of Expenses",
      style: TextStyle(fontSize: 30,),
      )
    );
  }
}