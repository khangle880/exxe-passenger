import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../data/models/models.dart';
import 'components/driver_detail_body.dart';

const double heightHeader = 250.0;

class DriverDetailPage extends StatefulWidget {
  const DriverDetailPage({super.key, this.carDriver});

  final CarDriverModel? carDriver;

  @override
  State<DriverDetailPage> createState() => _DriverDetailPageState();
}

class _DriverDetailPageState extends State<DriverDetailPage> {
  late final ExpandableController expandableController;
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    expandableController = ExpandableController(initialExpanded: true);
    _controller.addListener(() {
      bool isTop = _controller.position.pixels < 10;
      expandableController.expanded = isTop;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Thông tin tài xế',
        context: context,
        backgroundColor: AppColors.primaryButton.withAlpha(30),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              color: AppColors.primaryButton.withAlpha(30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ExpandablePanel(
                    controller: expandableController,
                    collapsed: _buildAvatarCollapsed(),
                    expanded: _buildAvatarItinerary(),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24),
                          topLeft: Radius.circular(24),
                        ),
                      ),
                      child: DriverDetailBody(
                        externalController: _controller,
                        carDriver: widget.carDriver!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAvatarItinerary() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: const ShapeDecoration(
              shape: CircleBorder(
                  side: BorderSide(color: AppColors.primaryButton)),
              color: AppColors.primaryLight,
            ),
            child: CustomNetworkImage(
              size: 140,
              decoration: const BoxDecoration(
                color: AppColors.gray20,
                shape: BoxShape.circle,
              ),
              host: Apis.baseUrl,
              url: widget.carDriver!.avatarUrl!.imageUrl!,
              errorImage: SvgPicture.asset(
                AppIcons.imagePicker,
                color: AppColors.gray60,
                width: 76,
                height: 76,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.carDriver!.partnerName!,
            style: AppStyles.s18w7,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  _buildAvatarCollapsed() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 12.0, left: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: const ShapeDecoration(
              shape: CircleBorder(
                  side: BorderSide(color: AppColors.primaryButton)),
              color: AppColors.primaryLight,
            ),
            child: CustomNetworkImage(
              size: 76,
              decoration: const BoxDecoration(
                color: AppColors.gray20,
                shape: BoxShape.circle,
              ),
              host: Apis.baseUrl,
              url: widget.carDriver!.avatarUrl!.imageUrl!,
              errorImage: SvgPicture.asset(
                AppIcons.imagePicker,
                color: AppColors.gray60,
                width: 76,
                height: 76,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.carDriver!.partnerName!,
                style: AppStyles.s18w7,
              ),
              const SizedBox(height: 8),
            ],
          )
        ],
      ),
    );
  }
}
