import 'package:flutter_dotenv/flutter_dotenv.dart';

class Apis {
  static String get baseUrl => dotenv.maybeGet('BASEURL', fallback: null) ?? "";
  static const String endPointWalletController = '/wallet_controller';

  static const String endPointMoneyRechargeWithdraw = '/payment_controller';

  static const String endPointCompoundingCarChatController =
      '/compounding_car_chat_controller';

  static const String endPointCompoundingCarNotificationController =
      '/compounding_car_notification_controller';

  static const String getListNotification =
      '/compounding_car_notification_controller/get_list_notification';
  static const String getDetailNotification =
      '/compounding_car_notification_controller/get_detail_notification';
  static const String readNotification =
      '/compounding_car_notification_controller/read_notification';
  static const String deleteNotification =
      '/compounding_car_notification_controller/delete_notification';
  static const String readAllNotification =
      '/compounding_car_notification_controller/read_all_notification';
  static const String deleteAllNotification =
      '/compounding_car_notification_controller/delete_all_notification';
  static const String endPointChatController = '/api/user';
  static const String loginChat = '/api/user/login';

  //? Car wallet apis
  static const String getPaymentRechargeMethods =
      "/payment_controller/get_payment_method_for_money_recharge";

  static const String createWalletRechargeRequest =
      "/wallet_controller/create_wallet_recharge_request";

  static const String confirmWalletRechargeRequest =
      "/wallet_controller/confirm_wallet_recharge_request";

  /// Lấy số tiền khả dụng có thể rút
  static const String getAvailableMoneyCanWithdrawing =
      "/wallet_controller/get_available_money_can_make_withdrawing_request";

  static const String createWithdrawingRequest =
      "/wallet_controller/make_money_withdrawing_request";

  static const String getAvailableMoneyInCashWalletRequest =
      '/wallet_controller/get_available_money_in_cash_wallet';

  static const String getWalletJournalRequest =
      '/wallet_controller/get_list_journal';

  static const String getTransactionDetailRequest =
      '/wallet_controller/get_detail_transaction';

  static const String getListTransactionByJournalRequest =
      '/wallet_controller/get_list_transaction_by_journal';

  static const String getListBank = '/wallet_controller/get_list_bank';

  static const String getAccountBank = '/wallet_controller/get_account_bank';

  static const String updateAccountBank =
      '/wallet_controller/update_account_bank';

  // check has bank info
  static const String checkBankInfo = '/wallet_controller/check_account_bank';

  //? User apis
  static const String endPointApiUserInformationController =
      '/user_information_controller';

  static const String getGeneralUserInfo =
      "/user_information_controller/get_general_user_information";

  static const String getUserInfo =
      '/user_information_controller/get_user_information';

  /// Đăng nhập bằng số điện thoại và mật khẩu
  static const String login = '/user_information_controller/login';

  /// Xóa thông tin tài khoản
  static const String deleteAccount =
      '/user_information_controller/delete_user_account';

  /// Dùng để lấy mã xác thực OTP về điện thoại khách hàng
  static const String sendOtp =
      '/connect_stringee_controller/send_otp_verification_message';

  /// Xác thực mã OTP là chính xác.
  static const String verifyOtp =
      '/connect_stringee_controller/verify_otp_code';

  /// Kiểm tra số điện thoại đã được đăng kí hay chưa
  static const String checkPhoneRegistered =
      '/user_information_controller/check_user_account';

  /// Đăng nhập bằng số điện thoại
  static const String authWithPhoneOtp = '/user_information_controller/auth';

  /// Kiểm tra tài khoản có mật khẩu trước đó chưa?
  static const String checkPasswordExist =
      '/user_information_controller/check_has_password';

  /// Khởi tạo mật khẩu mới (Tạo mật khẩu lần đầu)
  static const String createNewPassword =
      '/user_information_controller/create_new_password';

  /// Đổi mật khẩu khi tài khoản đã có mật khẩu
  static const String changePassword =
      '/user_information_controller/change-password';

  /// Lấy lại mật khẩu thông qua sms
  static const String resetPassword =
      '/user_information_controller/reset-password';

  /// Kiểm tra password
  static const String checkPassword =
      '/user_information_controller/check_password';

  //? User Info Apis
  /// Tạo mới thông tin Người Dùng (Account User).
  static const String createUserInformation =
      '/user_information_controller/create_user_information';

  /// Xác nhận thông tin tài khoản đăng kí với vai trò là tài xế
  static const String updateUserInformation =
      '/user_information_controller/update_user_information';

  /// Chuyển file Base64 thành đường dẫn URL cho avatar
  static const String createAvatarAttachment =
      '/detail_data_controller/create_attachment_data';

  /// Chuyển file Base64 thành đường dẫn URL
  static const String createAttachmentData =
      '/user_information_controller/create_attachment_data';

  /// Người dùng tạo xác thực số điện thoại chính chủ
  static const String createVerifiedNumberPhone =
      "/user_information_controller/create_verified_number_phone";

  /// Cập nhật lại ảnh xác thực số điện thoại chính chủ
  static const String updateVerifiedNumberPhone =
      '/user_information_controller/update_verified_number_phone';

  /// Lấy thông tin số điện thoại đã xác thực
  static const String getVerifiedNumberPhone =
      '/user_information_controller/get_verified_number_phone';

  //=========Verify account========//
  /// thông tin CMND/CC/HC
  static const String createIdentityCard =
      "/user_information_controller/create_identity_card";
  static const String updateIdentityCard =
      "/user_information_controller/update_identity_card";
  static const String getIdentityCard =
      "/user_information_controller/get_identity_card";

  /// thông tin người thân
  static const String createRelationshipInformation =
      "/user_information_controller/create_relationship_information";
  static const String deleteRelationshipInformation =
      "/user_information_controller/delete_relationship_information";
  static const String updateRelationshipInformation =
      "/user_information_controller/update_relationship_information";
  static const String getListRelationshipInformation =
      "/user_information_controller/get_list_relationship_information";
  static const String getDetailRelationshipInformation =
      "/user_information_controller/get_detail_relationship_information";

  //compounding_car_promotion_controller
  static const String getSpecialPromotion =
      '/compounding_car_promotion_controller/get_special_promotion';
  static const String getListPromotion =
      '/compounding_car_promotion_controller/get_list_promotion';
  static const String getListPromotionCanApply =
      '/compounding_car_promotion_controller/get_list_promotion_can_apply';
  static const String getPromotionDetail =
      '/compounding_car_promotion_controller/get_detail_promotion';
  static const String applyPromotionForCustomer =
      '/compounding_car_promotion_controller/apply_promotion_for_customer';
  static const String cancelApplyPromotion =
      '/compounding_car_promotion_controller/cancel_apply_promotion_for_customer';

  //?===========================================================================
  //? Compounding car customer controller apis
  //?===========================================================================

  static const String endPointCompoundingCarController =
      '/compounding_car_controller';

  /// Lấy thông tin những chuyến xe ghép khả dụng nhưng chưa được khởi hành
  /// Lấy danh sách những chuyến đi ghép mà khách hàng có thể đăng kí đi cùng
  static const String getCompoundingCarAvailable =
      "/compounding_car_controller/get_compounding_car_by_compounding";

  /// Tạo chuyến đi một chiều, hai chiều, đi ghép mới.
  static const String createCompoundingCar =
      "/compounding_car_controller/create_compounding_car";

  static const String updateCompoundingCar =
      "/compounding_car_controller/update_compounding_car";

  /// Xác nhận thông tin chuyến đi mới và tiến hành đặt cọc
  static const String confirmCompoundingCar =
      "/compounding_car_controller/confirm_compounding_car";

  /// Lấy thông tin HÓA ĐƠN ĐIỆN TỬ ĐÃ LƯU
  static const String getTaxCodeInformation =
      "/compounding_car_controller/get_tax_code_information";

  /// Lấy các phương thức thanh toán hiện đang có trên hệ thống
  static const String getPaymentInAppMethods =
      "/payment_controller/get_payment_method_in_app";

  /// Lấy phương thức thanh toán kết thúc chuyến đi
  static const String getPaymentFinalMethods =
      "/payment_controller/get_payment_method_for_final_payment";

  ///Huỷ đặt cọc khi hết giờ
  static const String depositTimeOut =
      "/compounding_car_controller/deposit_timeout_compounding_car_customer";

  /// Tạo đường dẫn đến VNP cho tạo chuyến mới
  static const String createVNPayDepositNew =
      "/vnpay_for_compounding_car_app_controller/create_payment";

  /// Cập nhật lại giao dịch thành công trên Server
  static const String confirmDepositPaymentNew =
      "/payment/vnpay/confirm_transaction";

  /// Xác nhận thanh toán thành công - Lấy trạng thái giao dịch đặt cọc.
  static const String getTransactionState =
      '/compounding_car_controller/get_transaction_state';

  /// Lấy trạng thái hoàn cọc theo chính sách hiện tại của công ty. Dành cho khách hàng
  static const String getReturnedDepositState =
      '/compounding_car_controller/get_returned_deposit_state';

  /// Lấy danh sách những lý do hủy chuyến đi
  static const String getCancelReasonCompoundingCar =
      "/compounding_car_controller/get_cancel_reason_compounding_car";

  /// Hủy tiến hành đặt cọc - Chuyến chuyến đi về dạng nháp
  /// Hủy chuyến đi trước khi tiến hành đặt cọc.
  /// UPDATE: Function này sẽ thêm chức năng hủy chuyến đi cho chuyển đi đang ở trạng thái: deposit, waiting, assign, waiting_customer"
  static const String cancelCompoundingCar =
      "/compounding_car_controller/cancel_compounding_car";

  /// Lấy lại lịch sử những chuyến đi
  static const String getHistoryCompoundingCarCustomer =
      "/compounding_car_controller/get_history_compounding_car_customer";

  /// Lấy thông tin chi tiết suất đi cùng chuyến đi ghép đã tạo trươc đó
  static const String getDetailCompoundingCarCustomer =
      "/compounding_car_controller/get_detail_compounding_car_customer";

  //?==========================================================================
  // add more passenger flow
  /// Lấy thông tin cơ bản về chuyến đi
  static const String getDetailCompoundingCar =
      "/compounding_car_controller/get_detail_compounding_car";

  /// Tạo một suất đi ghép cùng chuyến CHUYẾN ĐI GHÉP đã được tạo trước đó
  static const String createCompoundingCarCustomer =
      "/compounding_car_controller/create_compounding_car_customer";

  /// Lấy thông tin Gói cước chờ (Waiting_charge_block)
  static const String getWaitingChargeBlock =
      "/compounding_car_controller/get_waiting_charge_block";

  static const String confirmCompoundingCarCustomer =
      "/compounding_car_controller/confirm_compounding_car_customer";

  static const String deleteCompoundingCarCustomer =
      "/compounding_car_controller/delete_compounding_car";

  /// API dùng để khách hàng thanh toán số tiền còn lại của chuyến đi.
  /// Hiện tại chỉ đc thanh toán bằng ví exxe và cash
  /// Sau khi gọi api này tài xế sẽ confirm lại giao dịch bằng api bên tài xế
  static const String paymentRemainingOfCustomer =
      "/compounding_car_controller/payment_compounding_car_customer";

  /// Nếu thanh toán bằng vnpay
  /// Tạo hóa đơn thanh toán cho số tiên còn lại
  static const String createVNPayRemain =
      "/vnpay_for_compounding_car_app_controller/create_payment";

  /// Xác nhận thanh toán hóa đơn
  static const String confirmRemainingVnpayPayment =
      "/compounding_car_controller/confirm_payment_compounding_car";

  //rating controller
  static const String getQuickRatingTagRequest =
      "/rating_controller/get_quick_rating_tag";
  static const String createRatingRequest = "/rating_controller/create_rating";

  //
  static const String getListRatedCarDriver =
      "/rating_controller/get_list_rated_car_driver";

  //? Data controller Apis

  /// Lấy thông tin tỉnh/và điểm dừng của mỗi tỉnh
  static const String getAddress = "/address_controller/get_address_data";

  /// Lấy thong tin các hãng xe được thiết lập
  static const String getCarBrands = "/address_controller/get_car_brand_data";

  /// Lấy thông tin các loại xe đang được cung cấp
  static const String getCarTypes = "/address_controller/get_car_data";

  /// Lấy thông tin những địa điểm trạm dừng chân của một tỉnh
  static const String getPickupStation =
      "/address_controller/get_pick_up_station";

  /// Lấy thông tin về giá của chuyến đi theo từng loại xe
  static const String getCarFareTable =
      "/car_fare_table_controller/get_car_fare_table";

  static const String informationToComputePriceUnit =
      '/compounding_car_controller/information_to_compute_price_unit';

  /// API lấy thông tin huyện
  static const String getListDistrict =
      '/address_information_controller/get_list_district';

  /// API lấy thông tin xã
  static const String getListWard =
      '/address_information_controller/get_list_ward';

  ///Chat controller customer
  ///Api dùng để xử lí chat vs tài xế
  ///
  ///
  // Gửi tin nhắn
  static const String loginSocket = "/user/login";

  // get token socket
  static const String generateTokenSocket = '/user/generate_token';

  // Login to socket.io
  static const String sendMessage = "/message";

  // Lấy danh sách nhóm chat
  static const String getRoomChat = "/room";

  // Lấy chi tiết nhóm chat
  static const String getDetailRoomChat = "/room";

  ///=======================================================================///
  static String get baseNewsUrl =>
      dotenv.maybeGet('BASENEWSURL', fallback: null) ?? "";

  /// Lấy danh sách tin tức: limit, offset, categoryId
  static const String getPosts = "/post";

  /// sprintf id
  static const String getPostDetail = "/post";

  /// lấy danh sách danh mục
  static const String getNewsCategories = "/category";

  //?===========================================================================
  //? Push notification controller apis
  //?===========================================================================
  static const String loginDeviceForPartner =
      "/push_notification/login_device_for_partner";

  static const String logoutDeviceForPartner =
      "/push_notification/logout_device_for_partner";

  static const String call = "/compounding_car_controller/calling_notification";

  static const String missedCall =
      "/compounding_car_controller/missing_call_notification";

  static const String getNeedPaymentRides =
      "/compounding_car_controller/needing_payment_compounding_car_customer";
}
