import '../../../utils/parser_utils.dart';

class ElectricInvoiceModel {
  ElectricInvoiceModel({
    this.companyName,
    this.companyAddress,
    this.companyTaxCode,
    this.companyEmail,
    this.companyPhone,
  });

  ElectricInvoiceModel.fromJson(dynamic json) {
    companyName = safeParse(json['company_name']);
    companyAddress = safeParse(json['company_address']);
    companyTaxCode = safeParse(json['company_tax_code']);
    companyEmail = safeParse(json['company_email']);
    companyPhone = safeParse(json['company_phone']);
  }

  String? companyName;
  String? companyAddress;
  String? companyTaxCode;
  String? companyEmail;
  String? companyPhone;

  ElectricInvoiceModel copyWith({
    String? companyName,
    String? companyAddress,
    String? companyTaxCode,
    String? companyEmail,
    String? companyPhone,
  }) =>
      ElectricInvoiceModel(
        companyName: companyName ?? this.companyName,
        companyAddress: companyAddress ?? this.companyAddress,
        companyTaxCode: companyTaxCode ?? this.companyTaxCode,
        companyEmail: companyEmail ?? this.companyEmail,
        companyPhone: companyPhone ?? this.companyPhone,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_name'] = companyName;
    map['company_address'] = companyAddress;
    map['company_tax_code'] = companyTaxCode;
    map['company_email'] = companyEmail;
    map['company_phone'] = companyPhone;
    return map;
  }
}
