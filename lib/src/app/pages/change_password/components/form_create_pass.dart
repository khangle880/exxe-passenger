import '../../../../utils/export/ui_export.dart';
import '../controllers/change_password_cubit.dart';

class FormCreatePass extends StatelessWidget {
  const FormCreatePass({Key? key}) : super(key: key);

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
              canLogout: true,
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
                        "Mật khẩu mới",
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
                        "Xác nhận mật khẩu",
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
                    ButtonWidget(
                      onClick: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (formKey.currentState!.validate()) {
                          if (state.state == ChangePassState.create) {
                            cubit.createPassword();
                          } else if (state.state == ChangePassState.reset) {
                            cubit.resetPassword();
                          }
                        }
                      },
                      child: Text(
                        state.state == ChangePassState.reset
                            ? "Đặt lại mật khẩu"
                            : "Tạo mật khẩu",
                        style:
                            AppStyles.s16w6.withColor(AppColors.primaryLight),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
