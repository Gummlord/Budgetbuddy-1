import 'package:flutter/material.dart';

import '../features/expenses/screens/add_transaction_sheet.dart';

/// The single floating action button shared by every page of the app.
/// Tapping it opens the combined "Add Transaction" popup where expense and
/// income live in one form. Mounted once by the HomeShell so it is always
/// visible.
class AppFab extends StatelessWidget {
  const AppFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showAddTransactionSheet(context),
      child: const Icon(Icons.add),
    );
  }
}
