import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/table_account.dart';
import '../../services/service_locator.dart';
import '../../widgets/accounts/account_card.dart';
import '../invoice/invoice_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({
    super.key,
    required this.tableNumber,
    required this.zoneName,
  });

  final int tableNumber;
  final String zoneName;

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<TableAccount> get accounts {
    return Services.tables.getAccounts(widget.tableNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.zoneName} - Mesa ${widget.tableNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${accounts.length} cuenta'
              '${accounts.length == 1 ? '' : 's'} abierta'
              '${accounts.length == 1 ? '' : 's'}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: accounts.isEmpty
                  ? const _EmptyAccountsMessage()
                  : ListView.separated(
                      itemCount: accounts.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        final account = accounts[index];

                        return AccountCard(
                          customerName: account.customerName,
                          openingTime: _formatTime(account.openedAt),
                          total: account.subtotal,
                          productCount: account.totalItems,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InvoiceScreen(account: account),
                              ),
                            );

                            if (!mounted) {
                              return;
                            }

                            setState(() {});
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _showNewAccountDialog,
                icon: const Icon(Icons.add),
                label: const Text('NUEVA CUENTA'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showNewAccountDialog() async {
    String enteredName = '';

    final customerName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Nueva cuenta - Mesa ${widget.tableNumber}'),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre del cliente',
              hintText: 'Ejemplo: José',
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: (value) {
              enteredName = value.trim();
            },
            onSubmitted: (value) {
              final name = value.trim();

              if (name.isNotEmpty) {
                Navigator.pop(dialogContext, name);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                if (enteredName.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, enteredName);
              },
              child: const Text('CREAR'),
            ),
          ],
        );
      },
    );

    if (customerName == null || !mounted) {
      return;
    }

    final account = Services.tables.openAccount(
      tableNumber: widget.tableNumber,
      customerName: customerName,
    );

    if (account == null) {
      return;
    }

    setState(() {});
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}

class _EmptyAccountsMessage extends StatelessWidget {
  const _EmptyAccountsMessage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_add_alt_1_outlined,
            size: 54,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12),
          Text(
            'Esta mesa no tiene cuentas abiertas.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
