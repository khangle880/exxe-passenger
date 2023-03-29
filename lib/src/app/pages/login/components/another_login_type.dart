import 'package:exxe/src/utils/export/ui_export.dart';

class AnotherLoginType extends StatelessWidget {
  const AnotherLoginType(
      {Key? key,
      required this.ontap,
      required this.label,
      required this.methodLogin})
      : super(key: key);
  final Function(MethodLogin) ontap;
  final String label;
  final MethodLogin methodLogin;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppStyles.s14w6.withColor(AppColors.primaryMain),
    ).inkWell(
      onTap: () => ontap(methodLogin),
    );
  }
}
