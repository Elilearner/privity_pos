import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/open_account.dart';
import '../../services/service_locator.dart';
import '../invoice/invoice_screen.dart';

class BarScreen extends StatefulWidget {
  const BarScreen({super.key});

  @override
  State<BarScreen> createState() => _BarScreenState();
}

class _BarScreenState extends State<BarScreen> {
  @override
  void initState() {
    super.initState();

    Services.openAccounts.addListener(_handleAccountsChanged);
  }

  @override
  void dispose() {
    Services.openAccounts.removeListener(_handleAccountsChanged);

    super.dispose();
  }

  void _handleAccountsChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  List<OpenAccount> get _accounts {
    return Services.openAccounts.barAccounts;
  }

  @override
  Widget build(BuildContext context) {
    final accounts = _accounts;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BARRA',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Clientes con cuentas abiertas',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  '${accounts.length} abierta'
                  '${accounts.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: AppColors.goldLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: accounts.isEmpty
                ? const _EmptyBarMessage()
                : ListView.separated(
                    itemCount: accounts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final account = accounts[index];

                      return _BarAccountCard(
                        account: account,
                        onTap: () async {
                          await Navigator.of(context).push(
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
            height: 52,
            child: FilledButton.icon(
              onPressed: _showNewBarAccountDialog,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('NUEVA CUENTA EN BARRA'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showNewBarAccountDialog() async {
    String enteredName = '';

    final customerName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nueva cuenta en Barra'),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nombre del cliente',
              hintText: 'Ejemplo: Carlos',
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

    if (!mounted || customerName == null) {
      return;
    }

    final account = await Services.openAccounts.openBarAccount(
      customerName: customerName,
    );

    if (!mounted) {
      return;
    }

    if (account == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo crear la cuenta de Barra.')),
      );

      return;
    }

    setState(() {});

    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => InvoiceScreen(account: account)));

    if (!mounted) {
      return;
    }

    setState(() {});
  }
}

class _BarAccountCard extends StatelessWidget {
  const _BarAccountCard({required this.account, required this.onTap});

  final OpenAccount account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldLight),
                ),
                child: const Icon(
                  Icons.local_bar_outlined,
                  color: AppColors.goldLight,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.customerName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${account.totalItems} producto'
                      '${account.totalItems == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      _formatTime(account.openedAt),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'RD\$${account.subtotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.goldLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return 'Abierta $hour:$minute $period';
  }
}

class _EmptyBarMessage extends StatelessWidget {
  const _EmptyBarMessage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_bar_outlined,
            size: 58,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12),
          Text(
            'No hay cuentas abiertas en Barra.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          SizedBox(height: 5),
          Text(
            'Crea una cuenta usando el nombre del cliente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
