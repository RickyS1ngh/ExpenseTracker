import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Plane Ticket',
        amount: 131.99,
        date: DateTime.now(),
        category: Category.travel),
    Expense(
        title: 'Chiptole',
        amount: 17.40,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Movie Ticket',
        amount: 21.75,
        date: DateTime.now(),
        category: Category.leisure)
  ];
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex,
                    expense); //Expense is inserted back at the given position
              });
            }),
      ),
    );
  }

  void _openAddExpense() {
    showModalBottomSheet(
      useSafeArea: true, //makes sure to stay away from device features
      isScrollControlled: true, //modal overlay takes full height
      context: context,
      builder: (ctx) => NewExpense(_addExpense),
      constraints: const BoxConstraints(maxWidth: double.infinity),
    );
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(onPressed: _openAddExpense, icon: const Icon(Icons.add))
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(
                  expenses: _registeredExpenses,
                ),
                Expanded(
                  child: _registeredExpenses.isNotEmpty
                      ? ExpensesList(_removeExpense, _registeredExpenses)
                      : const Center(
                          child: Text("No Expenses Found!"),
                        ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(
                    expenses: _registeredExpenses,
                  ),
                ),
                Expanded(
                  child: _registeredExpenses.isNotEmpty
                      ? ExpensesList(_removeExpense, _registeredExpenses)
                      : const Center(
                          child: Text("No Expenses Found!"),
                        ),
                ),
              ],
            ),
    );
  }
}
