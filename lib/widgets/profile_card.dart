import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import '../models/tree_model.dart';
import '../models/user.dart';

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final userListRef = FirebaseFirestore.instance
      .collection("users")
      .withConverter<User>(
        fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

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
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  if (treeManager.tree.level == 0)
                    Lottie.asset(
                      'assets/animation_cry.json',
                      width: 60,
                      height: 60,
                    )
                  else
                    Image.asset(
                      'assets/images/level${treeManager.tree.level}.png',
                      width: 60,
                      height: 60,
                    ),
                  SizedBox(width: 10),
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
                                fontSize: 16,
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '레벨: ${treeManager.tree.level}',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                '경험치: ${treeManager.tree.experience} / 3500',
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }
}
