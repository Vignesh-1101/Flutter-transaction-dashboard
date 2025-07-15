import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import 'payout_form.dart';
import 'payout_history.dart';
import 'dart:async';

class TransactionDashboard extends StatefulWidget {
  const TransactionDashboard({super.key});

  @override
  State<TransactionDashboard> createState() => _TransactionDashboardState();
}

class _TransactionDashboardState extends State<TransactionDashboard> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchApi();
    Provider.of<TransactionProvider>(context, listen: false);
  }

  Future<void> _fetchApi() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    await provider.fetchTransactionsFromApi();
    if (mounted) setState(() => _loading = false);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green.shade600;
      case 'Pending':
        return Colors.orange.shade700;
      case 'Failed':
        return Colors.red.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transaction Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Payout History',
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PayoutHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                color: const Color(0xFFF6F7FB),
                child: Column(
                  children: [
                    _FiltersBar(),
                    const Divider(height: 1),
                    Expanded(
                      child: Consumer<TransactionProvider>(
                        builder: (context, provider, _) {
                          final transactions = provider.transactions;
                          if (transactions.isEmpty) {
                            return const Center(
                              child: Text('No transactions found.'),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: transactions.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final tx = transactions[index];
                              return Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap:
                                      () => Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder:
                                              (_, animation, __) =>
                                                  FadeTransition(
                                                    opacity: animation,
                                                    child: TransactionDetail(
                                                      transaction: tx,
                                                    ),
                                                  ),
                                          transitionsBuilder: (
                                            _,
                                            animation,
                                            __,
                                            child,
                                          ) {
                                            final offset = Tween<Offset>(
                                              begin: const Offset(1, 0),
                                              end: Offset.zero,
                                            ).animate(animation);
                                            return SlideTransition(
                                              position: offset,
                                              child: FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                      horizontal: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Colors.deepPurple.shade50,
                                          child: Icon(
                                            tx.type == 'Credit'
                                                ? Icons.arrow_downward
                                                : Icons.arrow_upward,
                                            color:
                                                tx.type == 'Credit'
                                                    ? Colors.green
                                                    : Colors.red,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '₹${tx.amount.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    size: 14,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    _formatDate(tx.date),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 4,
                                                    horizontal: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _statusColor(
                                                  tx.status,
                                                ).withAlpha(30),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                tx.status,
                                                style: TextStyle(
                                                  color: _statusColor(
                                                    tx.status,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              tx.type,
                                              style: TextStyle(
                                                color:
                                                    tx.type == 'Credit'
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.send, color: Colors.white),
        label: const Text('Payout', style: TextStyle(color: Colors.white)),
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const PayoutFormScreen()));
          if (result == true && context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Payout added!')));
          }
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _FiltersBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: provider.selectedStatus,
              hint: const Text('Status'),
              items:
                  const ['Success', 'Pending', 'Failed']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                provider.filterTransactions(
                  status: value,
                  dateRange: provider.selectedDateRange,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showDateRangeDialog(context),
              child: Text(
                provider.selectedDateRange == null
                    ? 'Date Range'
                    : '${provider.selectedDateRange!.start.year}-${provider.selectedDateRange!.start.month.toString().padLeft(2, '0')}-${provider.selectedDateRange!.start.day.toString().padLeft(2, '0')} - '
                        '${provider.selectedDateRange!.end.year}-${provider.selectedDateRange!.end.month.toString().padLeft(2, '0')}-${provider.selectedDateRange!.end.day.toString().padLeft(2, '0')}',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: provider.clearFilters,
          ),
        ],
      ),
    );
  }

  void _showDateRangeDialog(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    DateTimeRange? selectedRange = provider.selectedDateRange;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTimeRange? tempRange = selectedRange;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: const [
                  Icon(Icons.date_range, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Text(
                    'Select Date Range',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Filter transactions by a custom date range.',
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        tempRange?.start ?? DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      tempRange = DateTimeRange(
                                        start: picked,
                                        end: tempRange?.end ?? picked,
                                      );
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withAlpha(
                                      (0.07 * 255).toInt(),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Start Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.deepPurple,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            tempRange?.start != null
                                                ? '${tempRange?.start.day}/${tempRange?.start.month}/${tempRange?.start.year}'
                                                : 'Select',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        tempRange?.end ?? DateTime.now(),
                                    firstDate:
                                        tempRange?.start ?? DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      tempRange = DateTimeRange(
                                        start: tempRange?.start ?? picked,
                                        end: picked,
                                      );
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withAlpha(
                                      (0.07 * 255).toInt(),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'End Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.deepPurple,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            tempRange?.end != null
                                                ? '${tempRange?.end.day}/${tempRange?.end.month}/${tempRange?.end.year}'
                                                : 'Select',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                  child: const Text('Cancel'),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (tempRange != null) {
                        provider.filterTransactions(
                          status: provider.selectedStatus,
                          dateRange: tempRange,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    label: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TransactionDetail extends StatelessWidget {
  final Transaction transaction;
  const TransactionDetail({super.key, required this.transaction});

  Color _statusColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green.shade600;
      case 'Pending':
        return Colors.orange.shade700;
      case 'Failed':
        return Colors.red.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Transaction Detail',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 2,
      ),
      body: Container(
        color: const Color(0xFFF6F7FB),
        child: Center(
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.deepPurple.shade50,
                        child: Icon(
                          transaction.type == 'Credit'
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color:
                              transaction.type == 'Credit'
                                  ? Colors.green
                                  : Colors.red,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${transaction.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(
                                transaction.status,
                              ).withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              transaction.status,
                              style: TextStyle(
                                color: _statusColor(transaction.status),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  _detailRow(
                    Icons.calendar_today,
                    'Date',
                    _formatDate(transaction.date),
                  ),
                  _detailRow(Icons.info_outline, 'Type', transaction.type),
                  _detailRow(
                    Icons.description,
                    'Description',
                    transaction.description,
                  ),
                  _detailRow(Icons.confirmation_number, 'ID', transaction.id),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
