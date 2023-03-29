import '../../../../core/base_state.dart';
import '../../../../utils/export/ui_export.dart';
import '../../../common/widgets/dropdown_field.dart';
import '../components/required_text_field.dart';
import 'controllers/verify_relationship_cubit.dart';

class VerifyRelationshipPage extends StatefulWidget {
  const VerifyRelationshipPage({Key? key}) : super(key: key);

  @override
  State<VerifyRelationshipPage> createState() => _VerifyRelationshipPageState();
}

class _VerifyRelationshipPageState
    extends BaseState<VerifyRelationshipPage, VerifyRelationshipCubit> {
  final _formKey = GlobalKey<FormState>();

  @override
  late final VerifyRelationshipCubit bloc;

  @override
  void initState() {
    bloc = context.read<VerifyRelationshipCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc..loadRelationData(),
      child: BlocConsumer<VerifyRelationshipCubit, VerifyRelationshipState>(
        listener: (context, state) {
          if (state.relationshipModel != null) {
            Navigator.pop(context);
          }
        },
        buildWhen: (pre, cur) => pre.type != cur.type,
        builder: (context, state) {
          final isLoading = state.type == CallDataApiType.get;

          return Form(
            key: _formKey,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: AppColors.primaryLight,
                appBar: CustomAppBarWidget(
                  title: "Thông tin người thân",
                  context: context,
                ),
                body: isLoading
                    ? const SizedBox().appCenterProgressLoading
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildFormBody(state)),
                bottomNavigationBar: isLoading
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: ButtonWidget(
                                onClick: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    bloc.createVerifyEvent();
                                  }
                                },
                                radius: 12,
                                child: Text("Lưu",
                                    style: AppStyles.s16w6
                                        .withColor(AppColors.primaryLight)),
                              ),
                            ),
                            if (state.type == CallDataApiType.update) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: ButtonWidget(
                                  onClick: () async {
                                    bloc.deleteRelationship();
                                  },
                                  backgroundColor: AppColors.primaryMainBlur,
                                  radius: 12,
                                  border:
                                      Border.all(color: AppColors.primaryMain),
                                  child: Text(
                                    "Xoá",
                                    style: AppStyles.s16w6
                                        .withColor(AppColors.primaryMain),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  _buildFormBody(VerifyRelationshipState state) {
    return BlocBuilder<VerifyRelationshipCubit, VerifyRelationshipState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Text(
                "Thông tin của bạn sẽ được đảm bảo an toàn theo quy định của pháp luật",
                textAlign: TextAlign.center,
                style: AppStyles.s14w6.withColor(AppColors.gray60x9d),
              ),
            ),

            /// Full name
            RequiredTextField(
              initialValue: state.fullName ?? '',
              onChanged: (value) {
                bloc.updateFormField(fullName: value);
              },
              label: 'Họ và tên ',
              hintText: "Nhập họ và tên",
            ),
            const SizedBox(height: 24),

            /// Nhập số điện thoại
            RequiredTextField(
              initialValue: state.phone ?? '',
              onChanged: (value) {
                bloc.updateFormField(phone: value);
              },
              keyBoardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              label: 'Số điện thoại ',
              hintText: "Nhập số điện thoại",
            ),
            const SizedBox(height: 24),

            /// Relationship
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Mối quan hệ ",
                  style: AppStyles.s18w7,
                ),
                Text(
                  '*',
                  style: AppStyles.s14w7.withColor(AppColors.utilRed),
                ),
              ],
            ),
            const SizedBox(height: 4),
            CustomFormField(
              validator: (value) {
                if (state.relationship == null) {
                  return "Đây là một trường bắt buộc";
                }
                return null;
              },
              child: DropDownField<Relationship>(
                onSelected: (value) {
                  bloc.updateFormField(relationship: value);
                },
                list: Relationship.values,
                hintText: 'Mối quan hệ',
                initialValue: state.relationship,
                itemBuilder: (value) =>
                    Text(value.name.toString(), style: AppStyles.s16w4),
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
