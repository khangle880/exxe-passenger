import '../../../../utils/export/ui_export.dart';
import '../controllers/change_password_cubit.dart';

class FormChangePass extends StatelessWidget {
  const FormChangePass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final cubit = context.read<ChangePasswordCubit>();
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Scaffold(
            backgroundColor: AppColors.primaryLight,
            appBar: CustomAppBarWidget(
              title: 'Tạo mật khẩu mới',
              context: context,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "Mật khẩu bao gồm: tối thiểu 8 kí tự, chữ viết hoa, chữ thường và số.",
                      style: AppStyles.s14w4.withColor(AppColors.gray60x9d),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Mật khẩu hiện tại của bạn",
                        style: AppStyles.s18w7,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PasswordField(
                      (value) {
                        cubit.updateFormField(oldPass: value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng điền mật khẩu';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Mật khẩu mới của bạn",
                        style: AppStyles.s18w7,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PasswordField(
                      (value) {
                        cubit.updateFormField(newPass: value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng điền mật khẩu';
                        } else if (value == state.oldPass) {
                          return "Mật khẩu mới của bạn phải khác với mật khẩu đã sử dụng trước đó.";
                        }
                        final miss = [
                          value.isHas8Character() ? null : "tối thiểu 8 kí tự",
                          value.isHasUpper() ? null : "chữ viết hoa",
                          value.isHasLower() ? null : "chữ viết thường",
                          value.isHasDigit() ? null : "chữ số",
                        ].whereNotNull().join(', ').replaceLast(",", " và");
                        if (miss.isNotEmpty) {
                          return "Mật khẩu phải bao gồm: $miss";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Xác nhận mật khẩu mới",
                        style: AppStyles.s18w7,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PasswordField(
                      (value) {
                        cubit.updateFormField(rePassword: value);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng điền mật khẩu';
                        } else if (value != state.newPass) {
                          return "Hai mật khẩu phải trùng khớp nhau !";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: ButtonWidget(
                      onClick: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (formKey.currentState!.validate()) {
                          cubit.changePassword();
                        }
                      },
                      child: Text(
                        "Hoàn thành",
                        style:
                            AppStyles.s16w6.withColor(AppColors.primaryLight),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.maxFinite,
                    child: ButtonWidget(
                      backgroundColor: Colors.transparent,
                      onClick: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        final phoneNumber =
                            GetIt.I<AppState>().currentState.user?.phone;
                        if (phoneNumber == null) {
                          AppDialog.I.showWarning(
                              message:
                                  "Bạn không thể đặt lại mật khẩu vì chưa đăng ký số điện thoại");
                        } else {
                          Navigator.pushNamed(
                            context,
                            Routes.otp,
                            arguments: {
                              "phoneNumber":
                                  phoneNumber.convertToCountryPhoneCode(),
                              "sendPurpose": "reset_password",
                            },
                          ).then((value) {
                            if (value is String) {
                              cubit.updateFormField(stringeeToken: value);
                              cubit.changeState(ChangePassState.reset);
                            }
                          });
                        }
                      },
                      child: Text(
                        "Đặt lại mật khẩu",
                        style: AppStyles.s16w6.withColor(AppColors.primaryMain),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
