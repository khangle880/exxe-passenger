class AuthorModel {
  AuthorModel({
    this.authorId,
    this.authorName,
    this.authorAvatar,
    this.authorSocketId,
  });

  AuthorModel.fromJson(dynamic json) {
    authorId = json['author_id'];
    authorName = json['author_name'];
    authorAvatar = json['author_avatar'];
    authorSocketId = json['author_socket_id'];
  }

  String? authorId;
  String? authorName;
  String? authorAvatar;
  String? authorSocketId;

  AuthorModel copyWith({
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? authorSocketId,
  }) =>
      AuthorModel(
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        authorAvatar: authorAvatar ?? this.authorAvatar,
        authorSocketId: authorSocketId ?? this.authorSocketId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['author_id'] = authorId;
    map['author_name'] = authorName;
    map['author_avatar'] = authorAvatar;
    map['author_socket_id'] = authorSocketId;
    return map;
  }
}
