import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../data.dart';
import '../models/tree_model.dart';
import '../score_manager.dart';
import 'common_layout.dart';

class GardenPage extends StatefulWidget {
  const GardenPage({Key? key}) : super(key: key);

  @override
  _GardenPageState createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  bool _showHarvestAnimation = false;

  @override
  void initState() {
    super.initState();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstVisit = prefs.getBool('isFirstGardenVisit') ?? true;

    if (isFirstVisit) {
      _showIntroDialogs();
      await prefs.setBool('isFirstGardenVisit', false);
    }
  }

  void _showIntroDialogs() {
    List<String> messages = [
      '가상 정원 페이지에 오신 것을 환영합니다!',
      '처음에는 씨앗을 심고, 상점에서 물, 비료, 영양제 아이템을 구매하여 사용해 보세요.',
      '아이템을 사용하여 경험치를 쌓고, 경험치 500마다 진화 아이템을 사용해 나무를 성장시키세요.',
      '물 아이템: 경험치 +10\n비료 아이템: 경험치 +20\n영양제 아이템: 경험치 +50',
      '경험치가 500, 1000, 1500, 2000, 2500, 3000에 도달할 때마다 진화 아이템을 사용하여 나무를 진화시킬 수 있습니다.',
      '레벨 7에 도달하면 나무를 수확할 수 있습니다.'
    ];

    int currentMessageIndex = 0;

    void showNextDialog() {
      if (currentMessageIndex < messages.length) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('가상 정원 페이지 안내'),
              content: Text(messages[currentMessageIndex]),
              actions: [
                TextButton(
                  child: const Text('다음'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    currentMessageIndex++;
                    if (currentMessageIndex < messages.length) {
                      showNextDialog();
                    }
                  },
                ),
              ],
            );
          },
        );
      }
    }

    showNextDialog();
  }

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
        title: Text('포인트 부족'),
        content: Text('포인트가 부족합니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showPurchaseSuccessDialog(String itemName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('구매 완료'),
        content: Text('$itemName을(를) 구매했습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showEvolveWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경고'),
          content: const Text('진화하기 위해서는 더 많은 경험치가 필요합니다.'),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoEvolveItemWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경고'),
          content: const Text('진화 아이템이 없습니다.'),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMaxLevelWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경고'),
          content: const Text('더 이상 진화할 수 없습니다.'),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showWarning(BuildContext context, String warning) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('경고'),
          content: Text(warning),
          actions: [
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  

  void _harvest() async {
    setState(() {
      _showHarvestAnimation = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final scoreManager = Provider.of<ScoreManager>(context, listen: false);
      final treeManager = Provider.of<TreeManager>(context, listen: false);

      scoreManager.addApple();
      treeManager.resetTree();

      setState(() {
        _showHarvestAnimation = false; // 애니메이션을 다시 숨김
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사과를 1개 수확했습니다!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      selectedIndex: 2,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Consumer2<TreeManager, ItemData>(
                      builder: (context, treeManager, itemData, child) {
                        final evolveItem = itemData.items
                            .firstWhere((item) => item.name == '진화!');
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (treeManager.tree.level == 0) ...[
                              Lottie.asset(
                                'assets/animation_cry.json',
                                width: 150,
                                height: 150,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '씨앗을 심어주세요!',
                                style: TextStyle(fontSize: 20),
                              ),
                            ] else ...[
                              Text('나무 레벨: ${treeManager.tree.level}',
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(height: 16),
                              Image.asset(
                                'assets/images/level${treeManager.tree.level}.png',
                                height: 150,
                                width: 150,
                              ),
                              const SizedBox(height: 16),
                              Text('경험치: ${treeManager.tree.experience} / 3500',
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 16),
                              Container(
                                width: 250,
                                child: LinearProgressIndicator(
                                  value: treeManager.tree.experience / 3500,
                                  minHeight: 16,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  if (treeManager.tree.level >= 7) {
                                    _showMaxLevelWarning(context);
                                  } else if (treeManager.tree.experience >=
                                          (treeManager.tree.level * 500) &&
                                      evolveItem.quantity > 0) {
                                    treeManager.evolve();
                                    itemData.useItem('진화!');
                                  } else {
                                    if (evolveItem.quantity == 0) {
                                      _showWarning(context, "진화아이템이 없습니다.");
                                    } else {
                                      _showEvolveWarning(context);
                                    }
                                  }
                                },
                                child: const Text('진화하기',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            ],
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: (treeManager.tree.level == 7 &&
                                      treeManager.tree.experience == 3500)
                                  ? _harvest
                                  : null,
                              child: const Text('수확하기',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text('아이템 사용하기',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Consumer<ItemData>(
                        builder: (context, itemData, child) {
                          return Wrap(
                            spacing: 10,
                            children: [
                              _buildItemButton(
                                  context, itemData, '씨앗', Icons.grass, 0,
                                  isSeed: true),
                              _buildItemButton(
                                  context, itemData, '물', Icons.water_drop, 10),
                              _buildItemButton(
                                  context, itemData, '비료', Icons.eco, 20),
                              _buildItemButton(context, itemData, '영양제',
                                  Icons.local_florist, 50),
                              _buildItemButton(context, itemData, '진화!',
                                  Icons.auto_awesome, 0,
                                  isEvolve: true),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ShopSection(onPurchaseItem: _purchaseItem),
              ],
            ),
            if (_showHarvestAnimation)
              Center(
                child: Lottie.asset(
                  'assets/animation_harvest.json',
                  width: 200,
                  height: 200,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      if (mounted) {
                        setState(() {
                          _showHarvestAnimation = false;
                        });
                      }
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemButton(BuildContext context, ItemData itemData,
      String itemName, IconData icon, int exp,
      {bool isEvolve = false, bool isSeed = false}) {
    final treeManager = Provider.of<TreeManager>(context, listen: false);
    final item = itemData.items.firstWhere((item) => item.name == itemName);
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 32),
          onPressed: item.quantity > 0
              ? () {
                  if (isSeed) {
                    //TODO 씨앗 아이템인지 아닌지
                    if(treeManager.tree.isSeed == true){
                      _showWarning(context, '씨앗이 이미 심어져있습니다.');
                      print("씨앗이 이미 있음");         
                    }
                    else{
                      treeManager.plantSeed();
                      itemData.useItem(itemName);
                    }
                    
                  } else if (isEvolve) {
                    //진화 아이템인지 아닌지
                    if (treeManager.tree.isSeed == false) {
                      print("씨앗을 안심고 진화하려고함");
                      
                      _showWarning(context,"씨앗을 아직 심지않았습니다.");
                    } //씨앗을 안심엇는데 진화아이템을 누르면
                    else {
                      if (treeManager.tree.level >= 7) {
                        print("이미 레벨이 7 더이상 진화 못함");
                        _showWarning(context, "최고 레벨7에 도달했습니다. ");
                      } else if (treeManager.tree.experience >=
                              (treeManager.tree.level * 500) &&
                          item.quantity > 0) {
                        //개수가 어차피 0이상이었는데 쓸 필요X
                        treeManager.evolveWithItem();
                        itemData.useItem(itemName);
                      } else {
                        if (item.quantity == 0) {
                          //이거도 어차피 0이상으로 들어온건데 쓸 필요 X
                          print("아이템 없는데 사용하려함");
                          _showWarning(context,"$itemName 아이템이 없습니다.");
                        } else {
                          _showWarning(context,"진화를 하기위한 경험치가 부족합니다.");
                        }
                      }
                    }
                  } else {
                    //else 자체가 경험치 아이템이면
                    if (treeManager.tree.isSeed == false) {
                      _showWarning(context,"씨앗을 아직 심지않았습니다.");
                    } //이것도 씨앗 안심어져있다고 표시
                    else {
                      if ((treeManager.tree.experience) >=
                          (treeManager.tree.level * 500)) {
                        print("단계별 경험치 초과");
                        _showWarning(context,"경험치를 초과달성했습니다."); // 단계별 경험치 초과
                      } else {
                        treeManager.addExperience(exp);
                        itemData.useItem(itemName);
                      }
                    }
                  }
                }
              : () {
                  // if (isEvolve) {
                  //   _showWarning(context, "$itemName 아이템이 없습니다."); //TODO 아이템 없음으로 바꾸기
                  // }
                  _showWarning(context, "$itemName 아이템이 없습니다."); //TODO 아이템 없음으로 바꾸기
                },
        ),
        Text('$itemName (${item.quantity})',
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class ShopSection extends StatelessWidget {
  final Function(int) onPurchaseItem;

  ShopSection({required this.onPurchaseItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ScoreManager>(
            builder: (context, scoreManager, child) {
              return Text(
                '현재 포인트: ${scoreManager.totalPoints}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            },
          ),
          SizedBox(height: 10),
          Text('상점',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Consumer<ItemData>(
            builder: (context, itemData, child) {
              if (itemData == null || itemData.items.isEmpty) {
                return Text('아이템이 없습니다.');
              }

              return Wrap(
                spacing: 10,
                children: List.generate(itemData.items.length, (index) {
                  return Column(
                    children: [
                      IconButton(
                        icon: Icon(itemData.items[index].icon, size: 32),
                        onPressed: () {
                          onPurchaseItem(index);
                        },
                      ),
                      Text('${itemData.items[index].name}',
                          style: const TextStyle(fontSize: 14)),
                      Text('${itemData.items[index].price} 포인트',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
