import 'package:exxe/src/utils/export/ui_export.dart';

class  SocketModel {
  SocketModel({
    String? userId,
    String? userName,
    String? phone,
    Avatar? avatar,
    String? gender,
    String? bio,
    String? role,
    String? dateOfBirth,
    bool? isOnline,
    String? offlineAt,
    String? accessToken,
    String? refreshToken,
  }) {
    _userId = userId;
    _userName = userName;
    _phone = phone;
    _avatar = avatar;
    _gender = gender;
    _bio = bio;
    _role = role;
    _dateOfBirth = dateOfBirth;
    _isOnline = isOnline;
    _offlineAt = offlineAt;
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  String? _userId;
  String? _userName;
  String? _phone;
  Avatar? _avatar;
  String? _gender;
  String? _bio;
  String? _role;
  String? _dateOfBirth;
  bool? _isOnline;
  String? _offlineAt;
  String? _accessToken;
  String? _refreshToken;
  SocketModel.fromJson(dynamic json) {
    _userId = safeParse(json['user_id']);
    _userName = safeParse(json['user_name']);
    _phone = safeParse(json['phone']);
    _avatar = json['avatar'] != null ? Avatar.fromJson(json['avatar']) : null;
    _gender = safeParse(json['gender']);
    _bio = safeParse(json['bio']);
    _role = safeParse(json['role']);
    _dateOfBirth = safeParse(json['date_of_birth']);
    _isOnline = safeParse(json['is_online']);
    _offlineAt = safeParse(json['offline_at']);
    _accessToken = safeParse(json['access_token']);
    _refreshToken = safeParse(json['refresh_token']);
  }
  String? get userId => _userId;
  String? get userName => _userName;
  String? get phone => _phone;
  Avatar? get avatar => _avatar;
  String? get gender => _gender;
  String? get bio => _bio;
  String? get role => _role;
  String? get dateOfBirth => _dateOfBirth;
  bool? get isOnline => _isOnline;
  String? get offlineAt => _offlineAt;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
}

class Avatar {
  Avatar({
    String? attachmentId,
    String? thumbnailUrl,
    String? url,
    String? attachmentType,
  }) {
    _attachmentId = attachmentId;
    _thumbnailUrl = thumbnailUrl;
    _url = url;
    _attachmentType = attachmentType;
  }
  String? _attachmentId;
  String? _thumbnailUrl;
  String? _url;
  String? _attachmentType;
  Avatar.fromJson(dynamic json) {
    _attachmentId = safeParse(json['attachment_id']);
    _thumbnailUrl = safeParse(json['thumbnail_url']);
    _url = safeParse(json['url']);
    _attachmentType = safeParse(json['attachment_type']);
  }
  String? get attachmentId => _attachmentId;
  String? get thumbnailUrl => _thumbnailUrl;
  String? get url => _url;
  String? get attachmentType => _attachmentType;
}
