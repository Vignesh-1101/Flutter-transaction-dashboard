import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/payout.dart';

class PayoutHistoryScreen extends StatelessWidget {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payout History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ValueListenableBuilder<Box<Payout>>(
        valueListenable: Hive.box<Payout>('payouts').listenable(),
        builder: (context, box, _) {
          final payouts = box.values.toList().cast<Payout>().reversed.toList();
          if (payouts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.history, size: 64, color: Colors.deepPurple),
                  SizedBox(height: 16),
                  Text('No payout history yet', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: payouts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final payout = payouts[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade50,
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.deepPurple,
                    ),
                  ),
                  title: Text(
                    payout.beneficiaryName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('A/C: ${payout.accountNumber}'),
                      Text('IFSC: ${payout.ifsc}'),
                      Text('Date: ${_formatDate(payout.dateTime)}'),
                    ],
                  ),
                  trailing: Text(
                    '₹${payout.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
