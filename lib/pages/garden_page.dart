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

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      selectedIndex: 2,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        // appBar: AppBar(
        //   title: const Text('가상 정원'),
        // ),
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
                                      _showNoEvolveItemWarning(context);
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
                    treeManager.plantSeed();
                  } else if (isEvolve) {
                    if (treeManager.tree.level >= 7) {
                      _showMaxLevelWarning(context);
                    } else if (treeManager.tree.experience >=
                            (treeManager.tree.level * 500) &&
                        item.quantity > 0) {
                      treeManager.evolveWithItem();
                      itemData.useItem(itemName);
                    } else {
                      if (item.quantity == 0) {
                        _showNoEvolveItemWarning(context);
                      } else {
                        _showEvolveWarning(context);
                      }
                    }
                  } else {
                    treeManager.addExperience(exp);
                    itemData.useItem(itemName);
                  }
                }
              : () {
                  if (isEvolve) {
                    _showNoEvolveItemWarning(context);
                  }
                },
        ),
        Text('$itemName (${item.quantity})',
            style: const TextStyle(fontSize: 14)),
      ],
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

  void _harvest() async {
    setState(() {
      _showHarvestAnimation = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Provider.of<ScoreManager>(context, listen: false).addApple();
      Provider.of<TreeManager>(context, listen: false).resetTree();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('사과를 1개 수확했습니다!'),
      ));
    }
  }
}