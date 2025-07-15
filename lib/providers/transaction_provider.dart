import 'dart:async';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:dio/dio.dart';

class TransactionProvider extends ChangeNotifier {
  final List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];
  String? _selectedStatus;
  DateTimeRange? _selectedDateRange;
  // Timer? _simTimer; // Remove simulation timer

  TransactionProvider() {
    _filteredTransactions = List.from(_allTransactions);
  }

  List<Transaction> get transactions =>
      List.unmodifiable(_filteredTransactions);
  String? get selectedStatus => _selectedStatus;
  DateTimeRange? get selectedDateRange => _selectedDateRange;

  void filterTransactions({String? status, DateTimeRange? dateRange}) {
    _selectedStatus = status;
    _selectedDateRange = dateRange;
    _filteredTransactions =
        _allTransactions.where((tx) {
          final matchesStatus =
              status == null || status.isEmpty || tx.status == status;
          final matchesDate =
              dateRange == null ||
              (tx.date.isAtSameMomentAs(dateRange.start) ||
                      tx.date.isAfter(dateRange.start)) &&
                  (tx.date.isAtSameMomentAs(dateRange.end) ||
                      tx.date.isBefore(dateRange.end));
          return matchesStatus && matchesDate;
        }).toList();
    notifyListeners();
  }

  void clearFilters() {
    _selectedStatus = null;
    _selectedDateRange = null;
    _filteredTransactions = List.from(_allTransactions);
    notifyListeners();
  }

  Future<void> fetchTransactionsFromApi() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/posts',
      );
      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        _allTransactions.clear();
        for (var item in data.take(20)) {
          _allTransactions.add(
            Transaction(
              id: item['id'].toString(),
              amount: 1000 + (item['id'] as int) * 10.0, // demo amount
              date: DateTime.now().subtract(
                Duration(days: (item['id'] as int) % 30),
              ),
              type: (item['userId'] as int) % 2 == 0 ? 'Credit' : 'Debit',
              status: (item['userId'] as int) % 2 == 0 ? 'Success' : 'Pending',
              description: item['title'] ?? '',
            ),
          );
        }
        filterTransactions(
          status: _selectedStatus,
          dateRange: _selectedDateRange,
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
