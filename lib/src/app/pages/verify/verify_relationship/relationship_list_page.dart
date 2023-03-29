import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class RelationshipListPage extends StatefulWidget {
  const RelationshipListPage({Key? key}) : super(key: key);

  @override
  State<RelationshipListPage> createState() => _RelationshipListPageState();
}

class _RelationshipListPageState extends State<RelationshipListPage> {
  List<RelationshipInformationModel> relationships = [];

  @override
  initState() {
    super.initState();
    getListRelationship();
  }

  getListRelationship() {
    GetIt.I<IUserInfoRepo>().getListRelationshipInformation().then((value) {
      value.fold((l) => log(l.toString()), (r) {
        setState(() {
          relationships = r;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryLight,
      appBar: CustomAppBarWidget(
        title: "Thông tin người thân",
        context: context,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildBody(),
        ),
      ),
    );
  }

  _buildBody() {
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
        ...relationships.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.gray05,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 1,
                    color: AppColors.gray10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.name ?? "",
                        style: AppStyles.s16w6.withColor(AppColors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.phone ?? "",
                        style: AppStyles.s16w5.withColor(
                          AppColors.gray80.withOpacity(.95),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e.relationship!.name,
                      style: AppStyles.s16w5.withColor(
                        AppColors.primaryMain +
                            AppColors.primaryLight.withOpacity(.2),
                      ),
                    ),
                  )
                ],
              ),
            ).inkWell(onTap: () {
              Navigator.pushNamed(context, Routes.verifyRelationship,
                      arguments: e)
                  .then((value) {
                getListRelationship();
              });
            }),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.verifyRelationship,
                    arguments: null)
                .then((value) {
              getListRelationship();
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.gray05,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 1,
                  spreadRadius: 1,
                  color: AppColors.gray10,
                ),
              ],
            ),
            child: Row(
              children: [
                SvgPicture.asset(AppIcons.plus),
                const SizedBox(width: 32),
                Text(
                  "Thêm thông tin người thân",
                  style: AppStyles.s16w7.withColor(
                    AppColors.primaryMain + AppColors.black.withOpacity(.9),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
