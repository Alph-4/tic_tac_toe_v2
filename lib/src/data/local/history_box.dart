import 'package:hive/hive.dart';
import 'package:tic_tac_toe_v2/src/data/model/history_model.dart';

class HistoryBox {
  static const String historyBox = 'history_box';

  static Future<void> openBox() async {
    await Hive.openBox<HistoryModel>(historyBox);
  }

  static Box<HistoryModel> getHistoryBox() {
    final box = Hive.box<HistoryModel>(historyBox);
    return box;
  }

  static void setHistory(HistoryModel history) {
    final historyBox = getHistoryBox();
    historyBox.add(history);
  }

  static List<HistoryModel> getHistory() {
    final historyBox = getHistoryBox();
    final historyList = historyBox.values.toList();
    return historyList;
  }
}
