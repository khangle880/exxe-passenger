import 'avatar_url.dart';

class PartnerId {
  PartnerId({
      this.partnerId, 
      this.partnerName, 
      this.phone, 
      this.avatarUrl,});

  PartnerId.fromJson(dynamic json) {
    partnerId = json['partner_id'];
    partnerName = json['partner_name'];
    phone = json['phone'];
    avatarUrl = json['avatar_url'] != null ? AvatarUrl.fromJson(json['avatar_url']) : null;
  }
  num? partnerId;
  String? partnerName;
  String? phone;
  AvatarUrl? avatarUrl;
PartnerId copyWith({  num? partnerId,
  String? partnerName,
  String? phone,
  AvatarUrl? avatarUrl,
}) => PartnerId(  partnerId: partnerId ?? this.partnerId,
  partnerName: partnerName ?? this.partnerName,
  phone: phone ?? this.phone,
  avatarUrl: avatarUrl ?? this.avatarUrl,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['partner_id'] = partnerId;
    map['partner_name'] = partnerName;
    map['phone'] = phone;
    if (avatarUrl != null) {
      map['avatar_url'] = avatarUrl?.toJson();
    }
    return map;
  }

}