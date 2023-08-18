// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 1;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
        id: fields[0] as String,
        title: fields[1] as String,
        description: fields[2] as String,
        date: fields[3] as String?,
        time: fields[4] as String?,
        place: fields[5] as Place?,
        initialDistance: fields[6] as double?,
        isTracking: fields[7] as bool,
        isArrived: fields[8] as bool,
        isDone: fields[9] as bool?);
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.place)
      ..writeByte(6)
      ..write(obj.initialDistance)
      ..writeByte(7)
      ..write(obj.isTracking)
      ..writeByte(8)
      ..write(obj.isArrived)
      ..writeByte(9)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
