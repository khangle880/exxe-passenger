
import '../../utils/constants/constants.dart';
import '../../utils/parser_utils.dart';
import 'models.dart';

class ChatUserModel {
  ChatUserModel({
    this.userId,
    this.userName,
    this.avatar,
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.isOnline,
    this.offlineAt,
    this.role,
    this.isYourself,
    this.phone,
    this.accessToken,
    this.refreshToken,
  });

  ChatUserModel.fromJson(dynamic json) {
    userId = json['user_id'];
    userName = json['user_name'];
    avatar = json['avatar'];
    bio = json['bio'];
    dateOfBirth = safeParse(json['date_of_birth']);
    gender = json['gender'];
    isOnline = json['is_online'];
    offlineAt = safeParse(json['offline_at']);
    role = safeParse(json['role'], payload: CarAccountType.values);
    isYourself = json['is_yourself'];
    phone = json['phone'];
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  String? userId;
  String? userName;
  String? avatar;
  String? bio;
  DateTime? dateOfBirth;
  String? gender;
  bool? isOnline;
  DateTime? offlineAt;
  CarAccountType? role;
  bool? isYourself;
  String? phone;
  String? accessToken;
  String? refreshToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = userId;
    map['user_name'] = userName;
    map['avatar'] = avatar;
    map['bio'] = bio;
    map['date_of_birth'] = dateOfBirth;
    map['gender'] = gender;
    map['is_online'] = isOnline;
    map['offline_at'] = offlineAt;
    map['role'] = role;
    map['phone'] = phone;
    map['access_token'] = accessToken;
    map['refresh_token'] = refreshToken;
    return map;
  }

  ChatUserModel copyWith({
    String? userId,
    String? userName,
    String? avatar,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    bool? isOnline,
    DateTime? offlineAt,
    CarAccountType? role,
    bool? isYourself,
    String? phone,
    String? accessToken,
    String? refreshToken,
  }) {
    return ChatUserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isOnline: isOnline ?? this.isOnline,
      offlineAt: offlineAt ?? this.offlineAt,
      role: role ?? this.role,
      isYourself: isYourself ?? this.isYourself,
      phone: phone ?? this.phone,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  AuthorModel get toAuthorModel => AuthorModel(
        authorId: userId,
        authorName: userName,
        authorAvatar: avatar,
      );
}
