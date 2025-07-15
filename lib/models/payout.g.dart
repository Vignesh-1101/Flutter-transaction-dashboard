// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayoutAdapter extends TypeAdapter<Payout> {
  @override
  final int typeId = 0;

  @override
  Payout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Payout(
      beneficiaryName: fields[0] as String,
      accountNumber: fields[1] as String,
      ifsc: fields[2] as String,
      amount: fields[3] as double,
      dateTime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Payout obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.beneficiaryName)
      ..writeByte(1)
      ..write(obj.accountNumber)
      ..writeByte(2)
      ..write(obj.ifsc)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
