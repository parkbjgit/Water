import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tree_model.dart';
import '../score_manager.dart';
import '../widgets/profile_card.dart'; // 프로필 카드 임포트

class CommonLayout extends StatefulWidget {
  final Widget child;

  CommonLayout({required this.child});

  @override
  _CommonLayoutState createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
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
              child: ProfileCard(), // 프로필 카드 추가
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
                padding: const EdgeInsets.all(8.0),
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
            top: MediaQuery.of(context).size.height / 2 - 24,
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
                child: const Icon(Icons.arrow_forward, color: Colors.white),
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
