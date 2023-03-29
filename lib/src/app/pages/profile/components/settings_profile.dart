import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/models/models.dart';
import 'option_row.dart';

class SettingsProfile extends StatelessWidget {
  const SettingsProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Cài đặt',
            style: AppStyles.s16w7,
          ),
        ),
        OptionRow(
          title: 'Thông tin cá nhân',
          onTap: () {
            Navigator.pushNamed(context, Routes.formRegister, arguments: {
              'title': "Thông tin cá nhân",
              'description': "Tạo tài khoản EXXE để nhận tất cả các tính năng",
            });
          },
        ),
        OptionRow(
          title: 'Thông tin ngân hàng',
          onTap: () {
            Navigator.pushNamed(context, Routes.changeBankInfo);
          },
        ),
        OptionRow(
          title: 'Đổi mật khẩu',
          onTap: () {
            Navigator.pushNamed(context, Routes.changePassword).then((value) {
              if (value is bool && value || value is TokenModel) {
                if (value is TokenModel) {
                  GetIt.I<AppState>().logIn(value);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarBuilder.success(title: "Đổi mật khẩu thành công!"));
              }
            });
          },
        ),
        OptionRow(
          title: 'Ngôn ngữ',
          onTap: () => Navigator.pushNamed(context, Routes.changeLanguage),
        ),
      ],
    );
  }
}
