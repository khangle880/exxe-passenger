import '../../../utils/parser_utils.dart';

class ImageModel {
  ImageModel({
    this.id,
    this.url,
    this.idIcon,
    this.urlBankIcon,
  });

  ImageModel.fromJson(dynamic json) {
    id = safeParse(json['id']);
    url = safeParse(json['url']);
    idIcon = safeParse(json['image_id']);
    urlBankIcon = safeParse(json['image_url']);
  }

  num? id;
  String? url;
  num? idIcon;
  String? urlBankIcon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    return map;
  }

  ImageModel copyWith({
    num? id,
    String? url,
    num? idIcon,
    String? urlBankIcon,
  }) {
    return ImageModel(
      id: id ?? this.id,
      url: url ?? this.url,
      idIcon: idIcon ?? this.idIcon,
      urlBankIcon: urlBankIcon ?? this.urlBankIcon,
    );
  }
}
