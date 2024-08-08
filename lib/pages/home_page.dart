import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50, // 배경색을 여기에 설정
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('2ulip', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: '새로운 매치'),
              Tab(text: '히스토리'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: [
                    _buildListItem('연애할 때, 얼마나 자주 연락하는 게 좋나요?'),
                    _buildListItem('사랑하는 사람이 생긴다면, 결혼도 생각하게 될까요?'),
                    _buildListItem('결혼/출산 후 여자의 커리어는 어떠야 한다고 생각하나요?'),
                    _buildListItem('일과 가족 사이 우선순위는 어떻으면 하나요?'),
                    _buildListItem('평소 새로운 지식, 기술을 배우는 자기계발을 따로 하고 있나요?'),
                  ],
                ),
                Center(child: Text('히스토리 탭의 내용')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('SEARCH!free'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 8),
                Text('FEELING LUCKY!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}