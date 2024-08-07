import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../score_manager.dart';
import '../data.dart';
import 'common_layout.dart';

class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  Future<void> _purchaseItem(int index) async {
    final scoreManager = Provider.of<ScoreManager>(context, listen: false);
    final itemData = Provider.of<ItemData>(context, listen: false);
    if (scoreManager.totalPoints >= itemData.items[index].price) {
      scoreManager.subtractPoints(itemData.items[index].price);
      itemData.purchaseItem(index);
      _showPurchaseSuccessDialog(itemData.items[index].name);
    } else {
      _showInsufficientPointsDialog();
    }
  }

  void _showInsufficientPointsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("포인트 부족"),
        content: Text("포인트가 부족합니다."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  void _showPurchaseSuccessDialog(String itemName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("구매 완료"),
        content: Text("$itemName을(를) 구매했습니다."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text('포인트 및 리워드'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ItemData>(
                builder: (context, itemData, child) {
                  return ListView.builder(
                    itemCount: itemData.items.length,
                    itemBuilder: (context, index) {
                      bool isSeed = itemData.items[index].name == '씨앗';
                      bool isPurchased = itemData.items[index].purchased;
                      return Card(
                        color: isSeed && isPurchased ? Colors.grey[300] : null,
                        child: ListTile(
                          leading: Icon(itemData.items[index].icon),
                          title: Row(
                            children: [
                              Text(
                                itemData.items[index].name,
                                style: TextStyle(
                                  decoration: isSeed && isPurchased
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              if (isSeed && isPurchased)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '매진',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: Text('${itemData.items[index].price} 포인트'),
                          onTap: isSeed && isPurchased
                              ? null
                              : () => _purchaseItem(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('구매한 아이템', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Consumer<ItemData>(
                    builder: (context, itemData, child) {
                      return Wrap(
                        spacing: 10,
                        children: itemData.items
                            .map((item) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(item.icon, size: 40),
                                    Text('${item.name} (${item.quantity})'),
                                  ],
                                ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
