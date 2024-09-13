import 'package:riverpod/riverpod.dart';

final botProvider = AutoDisposeStateNotifierProvider<BotNotifier, bool?>((ref) {
  return BotNotifier();
});

class BotNotifier extends StateNotifier<bool?> {
  BotNotifier() : super(null);

  void blabla(bool value) {
    state = value;
  }

}
