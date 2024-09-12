import 'package:hive/hive.dart';
import 'package:tic_tac_toe_v2/src/data/model/history_hive_model.dart';


class HistoryBox {
  static const String historyBox = 'history_box';

  static Future<void> openBox() async {
    await Hive.openBox<HistoryModelHive>(historyBox);
  }

  static Box<HistoryModelHive> getHistoryBox() {
    final box = Hive.box<HistoryModelHive>(historyBox);
    return box;
  }

  static void setHistory(HistoryModelHive history) {
    final historyBox = getHistoryBox();
    historyBox.add(history);
  }

  static List<HistoryModelHive> getHistory() {
    final historyBox = getHistoryBox();
    final historyList = historyBox.values.toList();
    return historyList;
  }
}
