import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import '../controller/auth_login_bloc.dart';

class FormPhoneLogin extends StatefulWidget {
  const FormPhoneLogin({Key? key}) : super(key: key);

  @override
  State<FormPhoneLogin> createState() => _FormPhoneLoginState();
}

class _FormPhoneLoginState extends State<FormPhoneLogin> {
  bool showIconClearPhone = false;
  ValueNotifier<bool> showIconEye = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();
  late final AuthLoginBloc authLoginBloc;
  final phoneControl = TextEditingController();

  @override
  void dispose() {
    showIconEye.dispose();
    phoneControl.removeListener(() {
      _handelShowIconClearPhone();
    });
    super.dispose();
  }

  @override
  void initState() {
    authLoginBloc = BlocProvider.of<AuthLoginBloc>(context);
    phoneControl.addListener(() {
      _handelShowIconClearPhone();
    });
    super.initState();
  }

  _handelShowIconClearPhone() {
    if (phoneControl.text.isNotEmpty && !showIconClearPhone) {
      setState(() {
        showIconClearPhone = !showIconClearPhone;
      });
    } else if (phoneControl.text.isEmpty && showIconClearPhone) {
      setState(() {
        showIconClearPhone = !showIconClearPhone;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: BlocBuilder<AuthLoginBloc, AuthLoginState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // phone field
                TextFormFieldPhone(
                  controller: phoneControl,
                  textInputAction:
                      state.methodLogin == MethodLogin.phoneAndPassword
                          ? TextInputAction.next
                          : null,
                  onChanged: (value) {
                    if (value.length == 10) {
                      _handleTapLogin(_formKey, state.methodLogin);
                    }
                    authLoginBloc.add(
                      ChangedPhoneLoginEvent(
                        phone: value,
                        method:
                            value.length < 10 ? MethodLogin.checkPhone : null,
                      ),
                    );
                  },
                  contentPadding: const EdgeInsets.all(15.0),
                  suffixIcon: showIconClearPhone
                      ? InkWell(
                          onTap: () {
                            phoneControl.clear();
                            context
                                .read<AuthLoginBloc>()
                                .add(const ResetPhoneEvent());
                          },
                          child: const Icon(
                            Icons.clear,
                            size: 15.0,
                            color: AppColors.gray70x76,
                          ),
                        )
                      : null,
                ),

                // password
                if (state.methodLogin == MethodLogin.phoneAndPassword) ...[
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
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
                              : const Icon(
                                  Icons.visibility,
                                  size: 15.0,
                                ).inkWell(
                                  onTap: () =>
                                      showIconEye.value = !showIconEye.value,
                                ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20.0),
                buildButton(_formKey, context, state.methodLogin),
                if (state.methodLogin == MethodLogin.phoneAndPassword) ...[
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Đăng ký với OTP',
                          style:
                              AppStyles.s14w6.withColor(AppColors.primaryMain),
                        ).inkWell(
                          onTap: () {
                            authLoginBloc.add(
                              ChangedPhoneLoginEvent(
                                  phone: state.phone,
                                  method: MethodLogin.checkPhone),
                            );

                            setState(() {});
                          },
                        ),
                        ResetPassButton(
                          phoneNumber:
                              context.watch<AuthLoginBloc>().state.phone,
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    MethodLogin methodLogin,
  ) {
    late String title;
    if (methodLogin == MethodLogin.checkPhone) {
      title = "Tiếp tục";
    } else {
      title = "Đăng nhập";
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ButtonWidget(
        onClick: context.watch<AuthLoginBloc>().state.phone.length < 10
            ? null
            : () async {
                await _handleTapLogin(formKey, methodLogin);
              },
        child: Text(
          title,
          style: AppStyles.s16w6.withColor(AppColors.primaryLight),
        ),
      ),
    );
  }

  _handleTapLogin(formKey, MethodLogin methodLogin) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (methodLogin == MethodLogin.phoneAndPassword) {
      authLoginBloc.add(SubmitFormPhonePasswordEvent());
    } else {
      AppDialog.I.showLoading();
      final result =
          await GetIt.I<IUserRepo>().checkPhoneRegistered(phoneControl.text);
      AppDialog.I.closeDialog();

      result.fold(
        (failure) async {
          if (failure.toString().contains("Số điện thoại chưa được đăng kí!")) {
            jumpToOtp();
          } else {
            return failure.showDefaultDialog();
          }
        },
        (data) async {
          if (data.carAccountType != null &&
              data.carAccountType != CarAccountType.customer) {
            authLoginBloc
                .add(const UpdateStatusEvent(FormLoginStatus.notCompatible));
          } else {
            authLoginBloc.add(
              ChangedPhoneLoginEvent(
                  phone: authLoginBloc.state.phone,
                  method: MethodLogin.phoneAndPassword),
            );
          }
        },
      );
    }
  }

  jumpToOtp() async {
    Navigator.pushNamed(
      context,
      Routes.otp,
      arguments: {
        "phoneNumber": phoneControl.text.convertToCountryPhoneCode(),
      },
    ).then((value) async {
      if (value is String) {
        authLoginBloc.add(SubmitFormOTPEvent(value));
      }
    });
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
