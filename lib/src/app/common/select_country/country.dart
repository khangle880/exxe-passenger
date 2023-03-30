import 'country_codes.dart';

class Country {
  Country({
    this.phoneCode,
    this.languageCode,
    this.countryCode,
    this.name,
    this.displayName,
  });

  Country.fromJson(dynamic json) {
    phoneCode = json['phone_code'];
    languageCode = json['language_code'];
    countryCode = json['country_code'];
    name = json['name'];
    displayName = json['display_name'];
  }

  String? phoneCode;
  String? languageCode;
  String? countryCode;
  String? name;
  String? displayName;

  Country copyWith({
    String? phoneCode,
    String? languageCode,
    String? countryCode,
    String? name,
    String? displayName,
  }) =>
      Country(
        phoneCode: phoneCode ?? this.phoneCode,
        languageCode: languageCode ?? this.languageCode,
        countryCode: countryCode ?? this.countryCode,
        name: name ?? this.name,
        displayName: displayName ?? this.displayName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone_code'] = phoneCode;
    map['language_code'] = countryCode;
    map['country_code'] = countryCode;
    map['name'] = name;
    map['display_name'] = displayName;
    return map;
  }

  static List<Country> get supported {
    return countryCodes.map((country) => Country.fromJson(country)).toList();
  }
}
