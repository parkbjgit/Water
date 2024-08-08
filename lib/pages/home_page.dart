import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'common_layout.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  final dayLabels = ['월', '화', '수', '목', '금', '토', '일'];

  List<DateTime> _getWeekDates(DateTime now) {
    List<DateTime> weekDates = [];
    for (int i = 0; i < 7; i++) {
      weekDates.add(now.subtract(Duration(days: now.weekday - 1 - i)));
    }
    return weekDates;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('M월 d일');
    final todayDate = dateFormat.format(selectedDate);

    List<DateTime> weekDates = _getWeekDates(now);

    return CommonLayout(
      selectedIndex: 0,
      child: Container(
        color: Colors.blue.shade50, // 배경색을 여기에 설정
        child: ListView(
          children: [
            // 상단 알림 배너
            Container(
              color: Colors.blue[50],
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '💡 나의 물 사용량은?',
                      style: TextStyle(color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.close, color: Colors.amber),
                ],
              ),
            ),
            // 날짜 선택기와 캘린더
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$todayDate',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    children: List.generate(7, (index) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = weekDates[index];
                            });
                          },
                          child: _buildDateCircle(
                            dayLabels[index],
                            weekDates[index].day.toString(),
                            isSelected:
                                selectedDate.day == weekDates[index].day,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                '일간 미션',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            // 체크박스와 텍스트 입력 필드
            _buildCard(
              context,
              '7분 이하 짧은 샤워하기',
              Icons.check_circle_outline,
              '15분간 샤워를 하면 180L 전후의 물을 사용해요!',
              true,
              '100코인',
            ),
            _buildCard(context, '양치질 시 물컵 사용하기', Icons.check_circle_outline,
                '칫솔질 후 컵 없이 30초동안 양치질을 하면 5L 정도의 물이 낭비돼요!', true, '100코인'),
            _buildCard(
              context,
              '설거지 물 받아서 사용하기',
              Icons.check_circle_outline,
              '흐르는 물로 10분 동안 설거지하면 100L 물이 사용돼요! \n적절한 용량의 식기세척기를 사용해도 크게 절약할 수 있어요!',
              true,
              '100코인',
            ),
            _buildCard(
              context,
              '빨래 모아서 한번에 하기',
              Icons.check_circle_outline,
              '4인 가족 기준 하루 평균 세탁물은 하루 3Kg 정도에요. \n빨래를 3일치 모아서 빨면 경제적이에요!',
              true,
              '100코인',
            ),
            _buildCard(
              context,
              '절수형 샤워필터 사용하기',
              Icons.check_circle_outline,
              '절수형 샤워헤드의 최대유량은 1분당 7L로 일반형의 절반 정도에요!',
              true,
              '100코인',
            ),
            
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                '월간 미션',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            _buildCard(
              context,
              '양변기 수조에 1.5L 물병 넣기 ',
              Icons.check_circle_outline,
              '물병을 넣어놓으면 4인 가족 기준 하루 40L 가 절약돼요!',
              true,
              '100코인',
            ),
            _buildCard(
              context,
              '누수 여부 점검하기',
              Icons.check_circle_outline,
              '수도꼭지에서 1초에 두세 방울씩 물이 샌다고 가정했을 때 하루 65~100L의 물이 낭비돼요. \n만약 변기가 누수되면 더 많은 양의 물이 낭비돼요!',
              true,
              '100코인',
            ),
            // 아래 섹션은 반복되는 형태로 추가 가능
          ],
        ),
      ),
    );
  }

  Widget _buildDateCircle(String day, String date, {bool isSelected = false}) {
    return Column(
      children: [
        Text(day),
        SizedBox(height: 4),
        CircleAvatar(
          radius: 20,
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          child: Text(
            date,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon,
      String actionText, bool showCheckbox,
      [String? badge]) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              if (badge != null) ...[
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(badge, style: TextStyle(color: Colors.white)),
                ),
              ],
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 40, color: Colors.amber),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  actionText,
                  style: TextStyle(fontSize: 16),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              if (showCheckbox) Checkbox(value: true, onChanged: (value) {}),
            ],
          ),
        ],
      ),
    );
  }
}
