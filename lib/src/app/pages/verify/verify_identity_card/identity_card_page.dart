import '../../../../utils/export/ui_export.dart';
import '../../pages.dart';

class IdentityCardPage extends StatelessWidget {
  const IdentityCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VerifyIdentityCardBloc bloc = VerifyIdentityCardBloc(GetIt.I());
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return bloc..add(LoadInitialCardEvent());
        },
        child: BlocListener<VerifyIdentityCardBloc, VerifyIdentityCardState>(
          listenWhen: (pre, cur) => cur.identityCard != null,
          listener: (context, state) {
            final bloc = context.read<VerifyIdentityCardBloc>();
            if (!bloc.isIdentityCardEqualWithStateData(state)) {
              AppDialog.I.showSuccess(
                title: 'Xác minh thành công!',
                message: 'Tài khoản của bạn đã được xác minh',
                confirmText: "Hoàn tất",
                onConfirm: () {
                  AppDialog.I.closeDialog();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context, state.identityCard);
                  } else {
                    Navigator.pushReplacementNamed(context, Routes.home);
                  }
                },
                barrierDismissible: false,
              );
            } else {
              Navigator.pop(context, state.identityCard);
            }
          },
          child: BodyIdentityCardPage(bloc: bloc),
        ),
      ),
    );
  }
}
