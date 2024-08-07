import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../models/tree_model.dart';

class ProfileCard extends StatelessWidget {
  Future<String?> _getNickname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nickname');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TreeManager>(
      builder: (context, treeManager, child) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
              ],
            ),
        );
      },
    );
  }
}
