part of 'confirm_booking_cubit.dart';

class ConfirmBookingState extends Equatable {
  final bool isExxeRuleChecked;
  final bool isExportInvoiceChecked;
  final String? companyName;
  final String? companyAddress;
  final String? companyTaxCode;
  final String? companyEmail;
  final String? companyPhone;
  final CompoundingCarCustomerModel customerModel;

  const ConfirmBookingState({
    this.isExxeRuleChecked = false,
    this.isExportInvoiceChecked = false,
    this.companyName,
    this.companyAddress,
    this.companyTaxCode,
    this.companyEmail,
    this.companyPhone,
    required this.customerModel,
  });

  @override
  List<Object?> get props => [
        isExxeRuleChecked,
        isExportInvoiceChecked,
        companyName,
        companyAddress,
        companyTaxCode,
        companyEmail,
        companyPhone,
        customerModel,
      ];

  ConfirmBookingState copyWith({
    bool? isExxeRuleChecked,
    bool? isExportInvoiceChecked,
    String? companyName,
    String? companyAddress,
    String? companyTaxCode,
    String? companyEmail,
    String? companyPhone,
    CompoundingCarCustomerModel? customerModel,
  }) {
    return ConfirmBookingState(
      isExxeRuleChecked: isExxeRuleChecked ?? this.isExxeRuleChecked,
      isExportInvoiceChecked:
          isExportInvoiceChecked ?? this.isExportInvoiceChecked,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      companyTaxCode: companyTaxCode ?? this.companyTaxCode,
      companyEmail: companyEmail ?? this.companyEmail,
      companyPhone: companyPhone ?? this.companyPhone,
      customerModel: customerModel ?? this.customerModel,
    );
  }
}
