import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class HistoryModel {
  HistoryModel({
    required this.playerXName,
    required this.playerOName,
    required this.winner,
    DateTime? date,
  }) : date = date ?? DateTime.now();
  @HiveField(0)
  String playerXName;
  @HiveField(1)
  String playerOName;
  @HiveField(2)
  String? winner;
  @HiveField(3)
  DateTime date;
}
