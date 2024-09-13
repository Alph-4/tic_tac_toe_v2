import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class HistoryModelHive extends HiveObject {
  HistoryModelHive({
    required this.playerXName,
    required this.playerOName,
    required this.winner,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  @HiveField(1)
  String playerXName;
  @HiveField(2)
  String playerOName;
  @HiveField(3)
  String? winner;
  @HiveField(4)
  DateTime date;

  @override
  String toString() {
    return 'HistoryModelHive{playerXName: $playerXName, playerOName: $playerOName, winner: $winner, date: $date}';
  }
}
