import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../controllers/token/token_cubit.dart';
import '../../../core/base_state.dart';
import '../../../data/models/models.dart';
import '../verify/components/pickup_date_row.dart';
import 'controllers/form_register_bloc.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);
  final String title;
  final String description;

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState
    extends BaseState<RegisterFormPage, FormRegisterBloc> {
  final _formKey = GlobalKey<FormState>();
  @override
  late final FormRegisterBloc bloc;

  @override
  void initData() {
    super.initData();
    bloc = context.read<FormRegisterBloc>();
  }

  unFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormRegisterBloc, FormRegisterState>(
      listener: (context, state) {
        if (state.userInfo != null) {
          if (Navigator.canPop(context)) {
            if (!bloc.isUserInfoEqualWithFormRegisterData(state)) {
              AppDialog.I.showSuccess(
                title: 'Chỉnh sửa thành công',
                message: 'Thay đổi của bạn đã được lưu lại thành công!',
                confirmText: "Hoàn tất",
                onConfirm: () {
                  AppDialog.I.closeDialog();
                  Navigator.pop(context);
                },
                barrierDismissible: false,
              );
            } else {
              Navigator.pop(context);
            }
          } else {
            AppDialog.I.showSuccess(
              title: 'Đăng ký thành công',
              message: 'Thông tin đăng ký của bạn đã được lưu lại thành công!',
              confirmText: "Hoàn tất",
              onConfirm: () {
                AppDialog.I.closeDialog();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.home,
                  (_) => false,
                );
              },
              barrierDismissible: false,
            );
          }
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (Navigator.canPop(context)) {
              return true;
            } else {
              AppDialog.I.showWarning(
                message: "Bạn muốn đăng xuất khỏi tài khoản này?",
                onConfirm: () {
                  AppDialog.I.closeDialog();
                  context.read<TokenCubit>().logOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.login, (route) => false);
                },
              );
              return false;
            }
          },
          child: Form(
            key: _formKey,
            child: GestureDetector(
              onTap: unFocus,
              child: Scaffold(
                backgroundColor: AppColors.primaryLight,
                appBar: CustomAppBarWidget(
                  title: widget.title,
                  fontSizeTitle: 18,
                  context: context,
                  canLogout: true,
                ),
                body: state.type == CallDataApiType.get
                    ? const SizedBox().appCenterProgressLoading
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: _buildFormBody(),
                        ),
                      ),
                bottomNavigationBar: state.type == CallDataApiType.get
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: ButtonWidget(
                            onClick: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState!.validate()) {
                                bloc.add(CreateUserInformationEvent());
                              }
                            },
                            radius: 12,
                            child: Text("Xác nhận",
                                style: AppStyles.s16w6
                                    .withColor(AppColors.primaryLight)),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildFormBody() {
    return BlocBuilder<FormRegisterBloc, FormRegisterState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: AppStyles.s14w6.withColor(AppColors.gray60x9d),
              ),
            ),

            /// name
            TextFormFieldLabelTop(
              initialValue: state.name,
              label: 'Tên hiển thị ',
              isRequired: true,
              labelTextStyle: AppStyles.s16w7,
              hintText: "Nhập tên",
              textStyle: AppStyles.s16w4.withColor(AppColors.gray90x27),
              hintStyle: AppStyles.s16w4.withColor(AppColors.gray50),
              onChanged: (value) {
                bloc.add(ChangeFullNameEvent(value));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Đây là một trường bắt buộc";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Giới tính ',
                  style: AppStyles.s16w7,
                ),
                Text(
                  '*',
                  style: AppStyles.s14w7.withColor(AppColors.utilRed),
                )
              ],
            ),
            const SizedBox(height: 4),
            CustomFormField(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  height: 48,
                  child: PickupChip<Gender>(
                    list: Gender.values,
                    onSelected: (value) => bloc.add(ChangeGenderEvent(value)),
                    selectedItem: state.gender,
                    getName: (value) => value.name,
                    itemWidth: (constraints.maxWidth - 24) / 3,
                  ),
                );
              }),
              validator: (value) {
                if (state.gender == null) {
                  return "Đây là một trường bắt buộc";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            /// Birth Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ngày sinh ',
                  style: AppStyles.s16w7,
                ),
                Text(
                  '*',
                  style: AppStyles.s14w7.withColor(AppColors.utilRed),
                )
              ],
            ),
            const SizedBox(height: 4),
            CustomFormField(
              validator: (value) {
                if (state.birthDate == null) {
                  return "Đây là một trường bắt buộc";
                }
                return null;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray05,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: PickupDateRow(
                  selectedDate: state.birthDate,
                  onSelectDate: (date) {
                    bloc.add(ChangeBirthDateEvent(date));
                  },
                  dateFormat: 'dd.MM.yyyy',
                  view: DateRangePickerView.decade,
                  iconColor: AppColors.primaryMain,
                  style: AppStyles.s16w4,
                  selectedColor: AppColors.gray90x27,
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Phone
            TextFieldReadOnly(
              label: 'Số điện thoại ',
              hintText: bloc.userInfo.phone!,
              textStyle: AppStyles.s16w4.withColor(AppColors.gray60x9d),
              trailing: state.phoneConfirmed
                  ? SvgPicture.asset(
                      AppIcons.check,
                      height: 24,
                      width: 24,
                      color: AppColors.green60,
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.verifyPhoneNumber)
                            .then((value) {
                          bloc.add(
                              VerifyPhoneNumberEvent(value is bool && value));
                        });
                      },
                      child: Text(
                        "Xác minh",
                        style: AppStyles.s14w5.withColor(AppColors.primaryMain),
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            /// cmnd
            TextFieldReadOnly(
              label: 'CMND/CCCD',
              isRequired: false,
              hintText: state.identityNumber ?? "Nhập số chứng minh nhân dân",
              textStyle: AppStyles.s16w4.withColor(state.identityNumber != null
                  ? AppColors.gray90x27
                  : AppColors.gray50),
              onClick: () {
                unFocus();
                Navigator.pushNamed(context, Routes.verifyIdentityCard).then(
                  (value) {
                    if (value is IdentityCardModel) {
                      bloc.add(ChangeIdentityEvent(value.identityNumber!));
                    }
                  },
                );
              },
              trailing: SvgPicture.asset(
                AppIcons.directionRight,
                height: 16,
                width: 16,
                color: AppColors.gray95x14,
              ),
            ),
            const SizedBox(height: 24),

            /// email
            TextFormFieldLabelTop(
              initialValue: state.email,
              label: 'Email ',
              labelTextStyle: AppStyles.s16w7,
              hintText: "Nhập Email",
              textStyle: AppStyles.s16w4.withColor(AppColors.gray90x27),
              hintStyle: AppStyles.s16w4.withColor(AppColors.gray50),
              onChanged: (value) {
                bloc.add(ChangeEmailEvent(value));
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Đây là một trường bắt buộc";
                } else if (!value.isValidEmail()) {
                  return "Email không hợp lệ";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            /// Address
            GestureDetector(
              onTap: () {
                unFocus();
                Navigator.pushNamed(context, Routes.pickupAddress)
                    .then((value) {
                  if (value is LocationModel) {
                    bloc.add(ChangeAddress(value));
                  }
                });
              },
              child: TextFieldReadOnly(
                label: 'Địa chỉ ',
                isRequired: false,
                hintText: state.location?.fullAddress ?? "Nhập địa chỉ",
                textStyle: state.location != null
                    ? AppStyles.s14w4.withColor(AppColors.gray90x27)
                    : AppStyles.s16w4.withColor(AppColors.gray60x9d),
              ),
            ),
            const SizedBox(height: 24),

            /// relationship
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.centerLeft,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Thông tin liên hệ",
                        style: AppStyles.s14w6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SvgPicture.asset(
                      AppIcons.directionRight,
                      height: 16,
                      width: 16,
                      color: AppColors.gray95x14,
                    )
                  ],
                ),
              ),
            ).gestureDetector(onTap: () {
              Navigator.pushNamed(context, Routes.relationList);
            }),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
