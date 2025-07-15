import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionDetail extends StatelessWidget {
  final Transaction transaction;
  const TransactionDetail({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRow('ID', transaction.id),
            _buildRow('Amount', '₹${transaction.amount.toStringAsFixed(2)}'),
            _buildRow('Date', transaction.date.toString()),
            _buildRow('Type', transaction.type),
            _buildRow('Status', transaction.status),
            _buildRow('Description', transaction.description),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
