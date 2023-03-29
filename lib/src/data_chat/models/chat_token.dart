class ChatTokenModel {
  ChatTokenModel({
    this.accessToken,
    this.refreshToken,
  });

  ChatTokenModel.fromJson(dynamic json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  String? accessToken;
  String? refreshToken;

  ChatTokenModel copyWith({
    String? accessToken,
    String? refreshToken,
  }) =>
      ChatTokenModel(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['refresh_token'] = refreshToken;
    return map;
  }
}
