import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatApis {
  static String get baseUrl =>
      dotenv.maybeGet('BASECHATURL', fallback: null) ?? "";

  ///=============================User repo=================================///

  /// POST
  /// result: ChatUserModel
  /// body:
  //{
  //   "user_id": "string",
  //   "phone": "string",
  //   "password": "string",
  //   "role": "car_driver"
  //}
  static const String register = '/api/user';

  /// POST
  /// result: user_id
  static const String deleteAccount = '/api/user';

  /// POST
  /// result: ChatUserModel
  /// body:
  //{
  //   "phone": "string",
  //   "password": "string"
  //}
  static const String login = '/api/user/login';

  /// POST
  static const String logout = '/api/user/logout';

  /// POST
  /// Generate token from phone
  /// result: ChatTokenModel
  /// body:
  //{
  //   "user_id": 1,
  //   "phone": "0977066232"
  // }
  static const String generateToken = '/api/user/generate_token';

  /// GET
  /// result: has_password
  /// kiểm tra account đã có mật khẩu hay chưa
  static const String checkPassword = '/api/user/password';

  /// POST
  /// tạo mật khẩu trong trường hợp chưa có mật khẩu
  /// result: has_password
  /// body:
  //{
  //   "new_password": "string",
  //   "confirm_new_password": "string"
  // }
  static const String createPassword = '/api/user/password';

  /// PUT
  /// result: has_password
  /// body:
  //{
  //   "current_password": "string",
  //   "new_password": "string",
  //   "confirm_new_password": "string"
  // }
  static const String updatePassword = '/api/user/password';

  /// GET
  /// Lấy thông tin người dùng, không truyền tham số thì lấy thông tin của bản thân, truyền thì lấy của người được truyền
  /// result: ChatUserModel
  /// query: user_id
  static const String getProfile = '/api/user/profile';

  /// PUT
  /// Chỉnh sửa thông tin người dùng
  /// result: ChatUserModel
  /// body:
  //{
  //   "user_name": "user name",
  //   "avatar": "string",
  //   "bio": "string",
  //   "date_of_birth": "2000-11-15",
  //   "gender": "male"
  // }
  static const String updateProfile = '/api/user/profile';

  /// GET
  /// Lấy số tin nhắn chưa đọc theo user
  /// query: user_id
  static const String getMessageUnreadCount = '/api/user/message_unread_count';

  ///===========================Room repo=================================///
  /// POST
  /// Tạo phòng chat đơn
  /// result: ChatRoomModel
  /// body
  //{
  //   "partner_id": 0,
  //   "depend_id": 0
  // }
  static const String createSingleRoom = "/api/room/single";

  /// POST
  /// Tạo phòng chat nhóm
  /// result: ChatRoomModel
  /// body:
  //{
  //   "member_ids": [
  //     [
  //       1,
  //       2,
  //       3
  //     ]
  //   ],
  //   "room_avatar": "631a99cc79c11fc36845e297",
  //   "room_name": "string",
  //   "depend_id": "string"
  // }
  static const String createGroupRoom = "/api/room/group";

  /// DELETE
  /// Xóa cuộc hội  thoại bằng room id
  /// result: room_id
  /// path: room_id
  static const String deleteRoom = "/api/room/%s";

  /// GET
  /// Lấy chi tiết nhóm chat
  /// result: ChatRoomModel
  /// path: room_id
  static const String getRoom = "/api/room/%s";

  /// DELETE
  /// Dùng để xóa tất các cuộc hội thoại(đơn, nhóm) của tài xế đối với hành khách trong chuyến đi này, dùng trong trường hợp kết thúc chuyến đi, dành cho tài xế
  /// result: depend_id
  /// path: depend_id
  static const String deleteRoomDependId = "/api/room/depend_id/%s";

  /// PUT
  /// Khôi phục cuộc hội thoại
  /// result: room_id
  /// path: room_id
  static const String restoreRoom = "/api/room/restore/%s";

  /// DELETE
  /// Xóa tất cả tin nhắn chưa đọc trong room chat
  /// result: message_unread_count
  /// path: room_id
  static const String deleteUnreadByRoom = "/api/room/%s/message_unread";

  /// DELETE
  /// API này dành cho khách hàng sau khi hủy chuyến, chỉ dùng cho group chat
  /// path: depend_id
  static const String leaveGroupRoom = "/api/room/depend_id/%s/leave";

  /// POST
  /// API này được dùng trong trường hợp khách hàng tham gia nhóm chat sau khi đặt cọc thành công, chỉ dùng cho group chat
  /// path: depend_id
  static const String joinGroupRoom = "/api/room/depend_id/%s/join";

  /// GET
  /// Lấy danh sách phòng chat
  /// result: Paging<ChatRoomModel>
  /// query: offset, limit, search_term
  static const String getListRoom = "/api/room";

  /// GET
  /// Lấy danh sách ttin nhắn được ghim trong nhóm chat
  /// result: Paging<ChatMessageModel>
  /// path: room_id
  /// query: offset, limit
  static const String getPinnedMessages = "/api/room/%s/pinned_messages";

  /// POST
  /// Ghim tin nhắn vào nhóm chat
  /// result: ChatMessageModel
  /// body:
  //{
  //   "message_id": "631a99cc79c11fc36845e297"
  // }
  static const String pinnedMessage = "/api/room/pinned_message";

  /// DELETE
  /// Xóa tin nhắn đã ghim
  /// result: message_id
  /// path: message_id
  static const String deletePinnedMessage = "/api/room/pinned_message/%s";

  /// GET
  /// Lấy danh sách người dùng trong nhóm chat
  /// result: Paging<ChatUserModel>
  /// path: room_id
  /// query: offset, limit
  static const String getMembers = "/api/room/%s/members";

  /// GET
  /// Lấy danh sách tin nhắn trong nhóm chat
  /// result: Paging<ChatMessageModel>
  /// path: room_id
  /// query: offset, limit
  static const String getMessages = "/api/room/%s/messages";

  ///==============================Messsage repo==========================///
  /// GET
  /// Lấy danh sách những người đã đọc tin nhắn
  /// result: Paging<ChatUserModel>
  /// path: message_id
  /// query: offset, limit
  static const String getReadUsers = "/api/message/users/read/%s";

  /// PUT
  /// Xác nhận đã đọc tin nhắn
  /// result: message_id
  /// body:
  //{
  //   "message_id": "631a99cc79c11fc36845e297"
  // }
  static const String markReadMessage = "/api/message/read";

  /// PUT
  /// Xác nhận đã đọc hết tin nhắn trong room chat
  /// result: room_id
  /// body:
  //{
  //   "room_id": "631a99cc79c11fc36845e297"
  // }
  static const String markReadAllInRoom = "/api/message/read_all";

  /// POST
  /// Gửi tin nhắn
  /// result: ChatMessageModel
  /// body:
  //{
  //   "text": "string",
  //   "room_id": "string",
  //   "attachment_ids": [
  //     "string"
  //   ],
  //   "reply_to": {
  //     "message_id": "string",
  //     "attachment_id": "string"
  //   }
  // }
  static const String createMessage = "/api/message";

  /// GET
  /// lấy tin nhắn theo ID
  /// result: ChatMessageModel
  /// path: message_id
  static const String getMessage = "/api/message/%s";

  /// POST
  /// Bày tỏ cảm xúc tin nhắn
  /// result: ChatMessageModel
  /// body:
  // {
  //   "message_id": "string",
  //   "emotion": "like"
  // }
  static const String reactMessage = "/api/message/like";

  /// DELETE
  /// Bỏ thích tin nhắn
  /// result: ChatMessageModel
  /// path: message_id
  static const String deleteReactMessage = "/api/message/unlike/%s";

  /// GET
  /// Lấy danh sách những người đã react
  /// path: message_id
  static const String getReactUsers = "/api/message/users/like/%s";

  ///========================Attachment repo===============================///

  /// POST
  /// upload 1 image
  /// result: ChatAttachmentModel
  /// body:
  // name: string, filename: binary
  static const String uploadImageSingle = "/api/attachment/image/single";

  /// POST
  /// result: ChatAttachmentModel
  /// body:
  // name: string, filename: [binary]
  static const String uploadMultiImage = "/api/attachment/image/multiple";

  /// POST
  /// upload 1 video
  /// result: ChatAttachmentModel
  /// body:
  // name: string, filename: binary
  static const String uploadVideoSingle = "/api/attachment/video/single";

  /// POST
  /// result: ChatAttachmentModel
  /// body:
  // name: string, filename: [binary]
  static const String uploadVideoMulti = "/api/attachment/video/multiple";

  /// DELETE
  /// path: attachment_id
  static const String deleteAttachment = "/api/attachment/%s";
}
