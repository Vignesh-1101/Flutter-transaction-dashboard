import 'package:hive/hive.dart';
part 'payout.g.dart';

@HiveType(typeId: 0)
class Payout extends HiveObject {
  @HiveField(0)
  final String beneficiaryName;
  @HiveField(1)
  final String accountNumber;
  @HiveField(2)
  final String ifsc;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final DateTime dateTime;

  Payout({
    required this.beneficiaryName,
    required this.accountNumber,
    required this.ifsc,
    required this.amount,
    required this.dateTime,
  });
}
