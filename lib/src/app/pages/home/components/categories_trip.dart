import 'package:equatable/equatable.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class CategoriesTripHome extends StatelessWidget {
  const CategoriesTripHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildItemCategoryRide(
          models: CategoriesTripModels(
            name: CompoundingType.oneWay.name,
            color: Colors.blue,
            assets: AppIcons.oneWay,
          ),
          onClicked: () {
            GetIt.I<LocationHelper>().handleLocation(
              context,
              routeName: Routes.noCompoundingBook,
              args: {'type': CompoundingType.oneWay},
            );
          },
        ),
        _buildItemCategoryRide(
          models: CategoriesTripModels(
            name: CompoundingType.twoWay.name,
            color: Colors.green,
            assets: AppIcons.twoWay,
          ),
          onClicked: () {
            GetIt.I<LocationHelper>().handleLocation(
              context,
              routeName: Routes.noCompoundingBook,
              args: {'type': CompoundingType.twoWay},
            );
          },
        ),
        _buildItemCategoryRide(
          models: CategoriesTripModels(
            name: CompoundingType.convenient.name,
            color: AppColors.accOrgangeMain,
            assets: AppIcons.oneWay,
          ),
          iconColor: AppColors.accOrgangeMain,
          onClicked: () {
            GetIt.I<LocationHelper>().handleLocation(context,
                routeName: Routes.joinConvenientTrip,
                args: {'compoundingType': CompoundingType.convenient});
          },
        ),
        _buildItemCategoryRide(
          models: CategoriesTripModels(
            name: CompoundingType.compounding.name,
            color: AppColors.secondaryMain,
            assets: AppIcons.promo,
          ),
          iconColor: AppColors.secondaryMain,
          onClicked: () {
            Navigator.pushNamed(context, Routes.promotionHomePage);
          },
        ),
      ],
    );
  }

  Widget _buildItemCategoryRide(
      {required CategoriesTripModels models,
      Color? iconColor,
      required VoidCallback onClicked}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8.0),
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: models.color.withAlpha(15),
              borderRadius: AppStyles.border10,
            ),
            child: SvgPicture.asset(
              models.assets,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(models.name,
              style: AppStyles.s12w4.withColor(AppColors.gray70x76)),
          const SizedBox(height: 8.0),
        ],
      ).inkWell(onTap: onClicked),
    );
  }
}

class CategoriesTripModels extends Equatable {
  final String name;
  final Color color;
  final String assets;

  const CategoriesTripModels(
      {required this.name, required this.color, required this.assets});

  factory CategoriesTripModels.createCategoriesTrip(
          CategoriesTripModels models) =>
      CategoriesTripModels(
          name: models.name, color: models.color, assets: models.assets);

  @override
  List<Object?> get props => [name, color, assets];
}
