import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tic_tac_toe_v2/src/data/model/history_model.dart';
import 'package:tic_tac_toe_v2/src/data/source/local/history_box.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<HistoryModel> historyList = HistoryBox.getHistory();

    historyList.sort((a, b) => b.date.compareTo(a.date));
    return Scaffold(
      body: historyList.isEmpty
          ? const Center(
              child: Text(
                'No game history !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              decoration: BoxDecoration(
                                color: historyList[index].winner == 'X'
                                    ? Colors.blue
                                    : historyList[index].winner == 'draw'
                                        ? Colors.grey
                                        : Colors.purple,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 30),
                                child: Column(
                                  children: [
                                    Text(
                                      DateFormat('MMM d, y HH:mm').format(
                                          historyList[index].date.toLocal()),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          historyList[index].playerXName,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const Text(
                                          "VS",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          historyList[index].playerOName,
                                          style: const TextStyle(
                                            color: Colors.purple,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    childCount: historyList.length,
                  ),
                ),
              ],
            ),
    );
  }
}
