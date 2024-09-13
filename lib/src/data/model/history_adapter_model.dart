import 'package:hive/hive.dart';
import 'package:tic_tac_toe_v2/src/data/model/history_model.dart';

class HistoryModelAdapter extends TypeAdapter<HistoryModel> {
  @override
  final int typeId = 0;

  @override
  HistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return HistoryModel(
      playerXName: fields[0] as String,
      playerOName: fields[1] as String,
      winner: fields[2] as String,
      date: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.playerXName)
      ..writeByte(1)
      ..write(obj.playerOName)
      ..writeByte(2)
      ..write(obj.winner)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
