class User {
  int? point;
  int? userNo;
  String? userName;

  User({this.point, this.userNo, this.userName});

  User.fromJson(Map<String, Object?> json)
      : this(
          userNo: json['userNo'] as int,
          point: json['point'] as int,
          userName: json['userName'] as String,
        );

  //필요없을수도
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['point'] = point;
    data['userNo'] = userNo;
    data['userName'] = userName;
    return data;
  }
}
