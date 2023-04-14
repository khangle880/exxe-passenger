import '../../../../utils/export/ui_export.dart';
import '../controller/auth_login_bloc.dart';
import 'form_check_phone.dart';
import 'form_login_password.dart';

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
      child: BlocBuilder<AuthLoginBloc, AuthLoginState>(
        builder: (context, state) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: state.methodLogin == MethodLogin.checkPhone
                ? const FormCheckPhone()
                : const FormLoginPassword(),
          );
        },
      ),
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
