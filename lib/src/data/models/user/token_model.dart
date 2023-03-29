
import '../../../utils/utils.dart';

/// token : "9FOwx4jjAqgUPrd6ZHJQ7cZJAh15t4XNC2zrheI7NY6trMWByiZwWk1e9mzVQtVO6JKQ8tXeJ7Xl9y3LHB4Hzt2mAhYtLEEQBpkXqfOo2DKB1xdJSZrvLLwqc5uDiOcW"
/// refresh_token : "Q3tUFQfjCynIBH926KpnIsRIRIKjKSI2fZSRTDDILHNUlwP8gbVmKFGuKLRSjfYSwwibIJzguDgQYGFQKrBpOqinkMVbs1h9fn8OHimCxDtnEa1XWQbUKU7ILIVfEnfG"
/// car_account_type : "customer"

class TokenModel {
  TokenModel({
    String? token,
    String? refreshToken,
    CarAccountType? carAccountType,
  }) {
    _token = token;
    _refreshToken = refreshToken;
    _carAccountType = carAccountType;
  }

  TokenModel.fromJson(dynamic json) {
    _token = safeParse(json['token']);
    _refreshToken = safeParse(json['refresh_token']);
    _carAccountType = safeParse(json['car_account_type'], payload: CarAccountType.values);
  }

  String? _token;
  String? _refreshToken;
  CarAccountType? _carAccountType;

  TokenModel copyWith({
    String? token,
    String? refreshToken,
    CarAccountType? carAccountType,
  }) =>
      TokenModel(
        token: token ?? _token,
        refreshToken: refreshToken ?? _refreshToken,
        carAccountType: carAccountType ?? _carAccountType,
      );

  String? get token => _token;

  String? get refreshToken => _refreshToken;

  CarAccountType? get carAccountType => _carAccountType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['refresh_token'] = _refreshToken;
    map['car_account_type'] = _carAccountType;
    return map;
  }
}
