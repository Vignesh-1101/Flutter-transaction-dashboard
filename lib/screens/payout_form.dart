import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/payout.dart';

class PayoutFormScreen extends StatefulWidget {
  const PayoutFormScreen({super.key});

  @override
  State<PayoutFormScreen> createState() => _PayoutFormScreenState();
}

class _PayoutFormScreenState extends State<PayoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    final payout = Payout(
      beneficiaryName: _nameController.text.trim(),
      accountNumber: _accountController.text.trim(),
      ifsc: _ifscController.text.trim().toUpperCase(),
      amount: double.parse(_amountController.text.trim()),
      dateTime: DateTime.now(),
    );
    final box = Hive.box<Payout>('payouts');
    await box.add(payout);
    setState(() => _isSubmitting = false);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Payout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Beneficiary Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Enter beneficiary name'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountController,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty
                            ? 'Enter account number'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ifscController,
                decoration: const InputDecoration(
                  labelText: 'IFSC',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter IFSC code';
                  final regex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
                  if (!regex.hasMatch(v.trim().toUpperCase())) {
                    return 'Invalid IFSC code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter amount';
                  final amount = double.tryParse(v.trim());
                  if (amount == null) return 'Enter a valid number';
                  if (amount <= 10) return 'Amount must be > ₹10';
                  if (amount >= 100000) return 'Amount must be < ₹1,00,000';
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child:
                      _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
