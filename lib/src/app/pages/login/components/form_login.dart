import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import '../controller/auth_login_bloc.dart';
import 'another_login_type.dart';

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
  final passwordControl = TextEditingController();
  MethodLogin methodLogin = MethodLogin.PhoneAndPassword;

  @override
  void dispose() {
    passwordControl.dispose();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFormPhone(context, phoneControl, showIconClearPhone),
            if (methodLogin == MethodLogin.PhoneAndPassword) ...[
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
                    onEditingComplete: () => TextInput.finishAutofillContext(),
                    controller: passwordControl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng điền mật khẩu';
                      } else if (!value.isValidPassword()) {
                        return "Mật khẩu không hợp lệ";
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
            const SizedBox(height: 16.0),
            buildButton(_formKey, context, methodLogin),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnotherLoginType(
                    ontap: (typeMethod) {
                      if (typeMethod == MethodLogin.OTP) {
                        methodLogin = MethodLogin.PhoneAndPassword;
                      } else {
                        methodLogin = MethodLogin.OTP;
                      }
                      setState(() {});
                    },
                    label: methodLogin == MethodLogin.OTP
                        ? 'Đăng nhập'
                        : 'Đăng ký với OTP',
                    methodLogin: methodLogin,
                  ),
                  if (methodLogin != MethodLogin.OTP)
                    _buildResetPassButton(
                        context.watch<AuthLoginBloc>().state.phone),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFormPhone(BuildContext context,
      TextEditingController phoneControl, bool showIconClearPhone) {
    return TextFormFieldPhone(
        controller: phoneControl,
        textInputAction: methodLogin == MethodLogin.PhoneAndPassword
            ? TextInputAction.next
            : null,
        onChanged: (value) =>
            authLoginBloc.add(ChangedPhoneLoginEvent(phone: value)),
        contentPadding: const EdgeInsets.all(15.0),
        suffixIcon: showIconClearPhone
            ? InkWell(
                onTap: () {
                  phoneControl.clear();
                  context.read<AuthLoginBloc>().add(const ResetPhoneEvent());
                },
                child: const Icon(
                  Icons.clear,
                  size: 15.0,
                  color: AppColors.gray70x76,
                ),
              )
            : null);
  }

  Widget buildButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    MethodLogin methodLogin,
  ) {
    late String title;
    if (methodLogin == MethodLogin.OTP) {
      title = "Đăng ký";
    } else {
      title = "Đăng nhập";
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ButtonWidget(
        onClick: context.watch<AuthLoginBloc>().state.phone.length < 10
            ? null
            : () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (formKey.currentState!.validate()) {
                  if (methodLogin == MethodLogin.PhoneAndPassword) {
                    authLoginBloc.add(SubmitFormPhonePasswordEvent());
                  } else {
                    await Navigator.pushNamed(
                      context,
                      Routes.otp,
                      arguments: {
                        "phoneNumber":
                            phoneControl.text.convertToCountryPhoneCode(),
                      },
                    ).then((value) async {
                      if (value is String) {
                        authLoginBloc.add(SubmitFormOTPEvent(value));
                      }
                    });
                  }
                }
              },
        child: Text(
          title,
          style: AppStyles.s16w6.withColor(AppColors.primaryLight),
        ),
      ),
    );
  }

  _buildResetPassButton(String phoneNumber) {
    final canReset = phoneNumber.length >= 10;
    return Text(
      "Quên mật khẩu",
      style: AppStyles.s14w6
          .withColor(canReset ? AppColors.primaryMain : AppColors.gray50),
    ).inkWell(
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
                      arguments: {'stringeeToken': value},
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
    );
  }
}
