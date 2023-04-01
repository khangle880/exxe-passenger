import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';

class CheckPasswordDialog extends StatefulWidget {
  const CheckPasswordDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);
  final Function() onConfirm;

  @override
  State<CheckPasswordDialog> createState() => _CheckPasswordDialogState();
}

class _CheckPasswordDialogState extends State<CheckPasswordDialog> {
  final formKey = GlobalKey<FormState>();
  String password = "";
  String? checkResult;
  bool isChecking = false;

  checkPassword(String pass) async {
    setState(() {
      isChecking = true;
    });
    final result = await GetIt.I<IUserRepo>().checkPassword(pass);
    checkResult = result.fold((l) {
      return "Đã có lỗi xảy ra, vui lòng thử lại";
    }, (r) {
      if (r) {
        widget.onConfirm();
        return null;
      } else {
        return "Mật khẩu không chính xác";
      }
    });

    setState(() {
      isChecking = false;
    });

    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Form(
          key: formKey,
          child: Container(
            margin: EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.primaryMain +
                        AppColors.primaryLight.withOpacity(.95),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: isChecking
                      ? SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(
                              child: const SizedBox().appCenterProgressLoading),
                        )
                      : Image.asset(AppIcons.lock,
                          color: AppColors.primaryMain),
                ),
                const SizedBox(height: 8),
                Text(
                  "Kiểm tra mật khẩu",
                  style: AppStyles.s16w6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Vui lòng nhập mật khẩu để xác nhận",
                  style: AppStyles.s14w5,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                PasswordFieldOutline(
                  (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    return checkResult;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  child: ButtonWidget(
                    onClick: password.length < 8
                        ? null
                        : () {
                            checkPassword(password);
                          },
                    radius: 12,
                    child: Text(
                      "Đồng ý",
                      style: AppStyles.s14w6.withColor(AppColors.primaryLight),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
