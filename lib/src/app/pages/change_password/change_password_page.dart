import '../../../core/base_state.dart';
import '../../../utils/export/ui_export.dart';
import 'components/form_change_pass.dart';
import 'components/form_create_pass.dart';
import 'controllers/change_password_cubit.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key, this.onChanged}) : super(key: key);
  final void Function(BuildContext context)? onChanged;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState
    extends BaseState<ChangePasswordPage, ChangePasswordCubit> {
  late ChangePasswordCubit cubit;

  @override
  ChangePasswordCubit get bloc => cubit;

  @override
  void initData() {
    cubit = context.read<ChangePasswordCubit>();
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (_, state) {
        if (state.state == ChangePassState.changed) {
          if (widget.onChanged != null) {
            widget.onChanged?.call(context);
          } else {
            if (state.newToken != null) {
              Navigator.pop(context, state.newToken);
            } else {
              Navigator.pop(context, true);
            }
          }
        }
      },
      buildWhen: (pre, cur) => cur.state != ChangePassState.changed,
      builder: (context, state) {
        if (state.state == ChangePassState.checking) {
          return Scaffold(
            body: const SizedBox().appCenterProgressLoading,
          );
        }
        if (state.state == ChangePassState.update) {
          return const FormChangePass();
        }
        return const FormCreatePass();
      },
    );
  }
}
