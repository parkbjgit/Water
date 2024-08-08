import 'package:flutter/material.dart';
import 'common_layout.dart';
import '../widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      selectedIndex: 4,
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                ProfileCard(),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }
}
