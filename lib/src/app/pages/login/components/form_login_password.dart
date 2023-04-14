import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import '../controller/auth_login_bloc.dart';

class FormLoginPassword extends StatefulWidget {
  const FormLoginPassword({Key? key}) : super(key: key);

  @override
  State<FormLoginPassword> createState() => _FormLoginPasswordState();
}

class _FormLoginPasswordState extends State<FormLoginPassword> {
  bool showIconClearPhone = false;
  ValueNotifier<bool> showIconEye = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  late final AuthLoginBloc authLoginBloc;

  @override
  void dispose() {
    showIconEye.dispose();
    super.dispose();
  }

  @override
  void initState() {
    authLoginBloc = BlocProvider.of<AuthLoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthLoginBloc, AuthLoginState>(
      builder: (_, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.directionLeftBold,
                    height: 24,
                    width: 24,
                    color: AppColors.primaryMain,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Xin chào, ${state.phone}",
                        style: AppStyles.s20w7.withColor(AppColors.primaryMain),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Ứng dụng cho tài xế ExxeVN",
                        style: AppStyles.s14w4.withColor(AppColors.gray60x52),
                      ),
                    ],
                  ),
                ],
              ).inkWell(
                onTap: () {
                  authLoginBloc.add(
                    ChangedPhoneLoginEvent(
                        phone: state.phone, method: MethodLogin.checkPhone),
                  );
                },
              ),
              const SizedBox(height: 24),
              AutofillGroup(
                child: ValueListenableBuilder(
                  valueListenable: showIconEye,
                  builder: (context, bool valueEye, child) {
                    return TextFormFieldBuilder.none(
                      onChanged: (value) => authLoginBloc
                          .add(ChangedPasswordLoginEvent(password: value)),
                      obscureText: valueEye,
                      autofillHints: const [AutofillHints.password],
                      filledColor: AppColors.white,
                      onEditingComplete: () =>
                          TextInput.finishAutofillContext(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng điền mật khẩu';
                        }
                        return null;
                      },
                      hintText: 'Nhập mật khẩu',
                      keyboardType: TextInputType.visiblePassword,
                      contentPadding: const EdgeInsets.all(15.0),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: (valueEye)
                            ? InkWell(
                                onTap: () =>
                                    showIconEye.value = !showIconEye.value,
                                child: const Icon(
                                  Icons.visibility_off,
                                  size: 15.0,
                                ),
                              )
                            : GestureDetector(
                                onTap: () =>
                                    showIconEye.value = !showIconEye.value,
                                child: const Icon(
                                  Icons.visibility,
                                  size: 15.0,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ButtonWidget(
                onClick: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    authLoginBloc.add(SubmitFormPhonePasswordEvent());
                  }
                },
                child: Text(
                  "Đăng nhập",
                  style: AppStyles.s16w6.withColor(AppColors.primaryLight),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ResetPassButton(
                      phoneNumber: context.watch<AuthLoginBloc>().state.phone,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ResetPassButton extends StatelessWidget {
  const ResetPassButton({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final authLoginBloc = BlocProvider.of<AuthLoginBloc>(context);
    final canReset = phoneNumber.length >= 10;
    return GestureDetector(
      onTap: canReset
          ? () async {
              AppDialog.I.showLoading();
              final result =
                  await GetIt.I<IUserRepo>().checkPhoneRegistered(phoneNumber);
              AppDialog.I.closeDialog();
              result.fold((failure) => failure.showDefaultDialog(), (data) {
                Navigator.pushNamed(
                  context,
                  Routes.otp,
                  arguments: {
                    "phoneNumber": phoneNumber.convertToCountryPhoneCode(),
                    "sendPurpose": "reset_password",
                  },
                ).then((value) {
                  if (value is String) {
                    Navigator.pushNamed(
                      context,
                      Routes.changePassword,
                      arguments: {'token': value},
                    ).then((value) {
                      if (value is TokenModel) {
                        authLoginBloc.add(ResetPasswordEvent(token: value));
                      }
                    });
                  }
                });
              });
            }
          : null,
      child: Text(
        "Quên mật khẩu",
        style: AppStyles.s14w6
            .withColor(canReset ? AppColors.primaryMain : AppColors.gray50),
      ),
    );
  }
}
