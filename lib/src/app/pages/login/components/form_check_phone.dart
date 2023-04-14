import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import '../controller/auth_login_bloc.dart';

class FormCheckPhone extends StatefulWidget {
  const FormCheckPhone({Key? key}) : super(key: key);

  @override
  State<FormCheckPhone> createState() => _FormCheckPhoneState();
}

class _FormCheckPhoneState extends State<FormCheckPhone> {
  bool showIconClearPhone = false;
  late final AuthLoginBloc authLoginBloc;
  final phoneControl = TextEditingController();

  @override
  void dispose() {
    phoneControl.removeListener(() {
      _handelShowIconClearPhone();
    });
    phoneControl.dispose();
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
    return BlocBuilder<AuthLoginBloc, AuthLoginState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              "Dành cho tài xế",
              style: AppStyles.s20w7.withColor(AppColors.primaryMain),
            ),
            const SizedBox(height: 4),
            Text(
              "Ứng dụng cho tài xế ExxeVN",
              style: AppStyles.s14w4.withColor(AppColors.gray60x52),
            ),
            const SizedBox(height: 24),
            TextFormFieldPhone(
              controller: phoneControl,
              textInputAction: state.methodLogin == MethodLogin.phoneAndPassword
                  ? TextInputAction.next
                  : null,
              onChanged: (value) {
                if (value.length == 10) {
                  _checkUserAccount();
                }
                authLoginBloc.add(
                  ChangedPhoneLoginEvent(
                    phone: value,
                    method: value.length < 10 ? MethodLogin.checkPhone : null,
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
            const SizedBox(height: 16.0),
            ButtonWidget(
              onClick: context.watch<AuthLoginBloc>().state.phone.length < 10
                  ? null
                  : () async {
                      _checkUserAccount();
                    },
              child: Text(
                "Tiếp tục",
                style: AppStyles.s16w6.withColor(AppColors.primaryLight),
              ),
            ),
          ],
        );
      },
    );
  }

  _checkUserAccount() async {
    FocusManager.instance.primaryFocus?.unfocus();
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
