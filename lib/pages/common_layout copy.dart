import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tree_model.dart';
import '../score_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonLayout extends StatefulWidget {
  final Widget child;

  CommonLayout({required this.child});

  @override
  _CommonLayoutState createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
  Future<String?> _getNickname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nickname');
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1C1B1F),
              ),
              // child: ProfileCard(), // 프로필 카드 추가  TODO: 수정 필요
              child: 
              Consumer<TreeManager>(
                builder: (context, treeManager, child) {
                  return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: 
                  Column(children: [
                    Row(
                  children: [
                    if (treeManager.tree.level == 0)
                      Lottie.asset(
                        'assets/animation_cry.json',
                        width: 60, // 이미지 너비 조정
                        height: 60, // 이미지 높이 조정
                      )
                    else
                      Image.asset(
                        'assets/images/level${treeManager.tree.level}.png',
                        width: 60, // 이미지 너비 조정
                        height: 60, // 이미지 높이 조정
                      ),
                      SizedBox(width: 10), // 간격 조정
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String?>(
                          future: _getNickname(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                snapshot.data ?? '닉네임 없음',
                                style: TextStyle(
                                  fontSize: 16, // 글자 크기 조정
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 4),
                        Text(
                          '내 나무의 현재 상태',
                          style: TextStyle(
                            fontSize: 14, // 글자 크기 조정
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8), // 간격 조정
                Text(
                  '레벨: ${treeManager.tree.level}',
                  style: TextStyle(fontSize: 10), // 글자 크기 조정
                ),
                Text(
                  '경험치: ${treeManager.tree.experience} / 3500',
                  style: TextStyle(fontSize: 10), // 글자 크기 조정
                ),

                  ],)
                
                
                );
                
                
                },
                ),
            
            ),
            const SizedBox(height: 16), // 헤더와 아이템 사이의 간격 추가
            _buildDrawerItem(Icons.assignment, '미션', '/mission'),
            _buildDrawerItem(Icons.quiz, '퀴즈', '/quiz'),
            _buildDrawerItem(Icons.local_florist, '가상 정원', '/garden'),
            _buildDrawerItem(Icons.store, '상점', '/reward'),
            _buildDrawerItem(Icons.water_damage, '물 사용량', '/water_usage'),
            _buildDrawerItem(Icons.map, '지도', '/map'),
            _buildDrawerItem(Icons.leaderboard, '리더보드', '/leaderboard'),
            _buildDrawerItem(Icons.login, '로그인', '/login'),
            _buildDrawerItem(Icons.person, '프로필', '/profile'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: widget.child),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Consumer<ScoreManager>(
                  builder: (context, scoreManager, child) {
                    return Text(
                      '내 보유 포인트: ${scoreManager.totalPoints}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            // top: MediaQuery.of(context).size.height / 2 - 24,
            top: 50, // TODO : 위치 나중에 수정
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }
}
