import 'dart:async';

import 'package:expandable_page_view/expandable_page_view.dart';

import '../../../../utils/export/ui_export.dart';
import '../button_widget.dart';

class PickupNumberGridView extends StatefulWidget {
  const PickupNumberGridView({
    Key? key,
    required this.onSelected,
    this.initValue,
    this.start,
    this.end,
    this.initialViewValue,
  }) : super(key: key);
  final void Function(int? value) onSelected;
  final int? initValue;
  final int? start;
  final int? end;
  final int? initialViewValue;

  @override
  State<PickupNumberGridView> createState() => _PickupNumberGridViewState();
}

class _PickupNumberGridViewState extends State<PickupNumberGridView> {
  late final int start;
  late final int end;
  late final PageController _pageController;
  int? selected;
  late final StreamController<String> headerStream;

  @override
  void initState() {
    super.initState();
    start = widget.start ?? 1900;
    end = widget.end ?? 2100;
    int total = end - start + 1;
    if (widget.initialViewValue != null || widget.initValue != null) {
      _pageController = PageController(
          initialPage:
              ((widget.initialViewValue ?? widget.initValue)! - start) ~/ 15,
          keepPage: true);
    } else {
      _pageController = PageController(initialPage: total ~/ 15);
    }
    headerStream = StreamController<String>();
    _pageController.addListener(() {
      updateHeader();
    });
    selected = widget.initValue;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateHeader();
    });
  }

  void updateHeader() {
    final int offset = 15 * (_pageController.page?.toInt() ?? 0);
    final header = "${start + offset} - ${start + offset + 15}";
    headerStream.add(header);
  }

  int get totalPage => (end - start + 14) ~/ 15;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    AppIcons.chevronLeft,
                    color: AppColors.primaryMain,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<String>(
                    stream: headerStream.stream,
                    builder: (context, snapshot) {
                      return Text(snapshot.data ?? "",
                          textAlign: TextAlign.center, style: AppStyles.s18w6);
                    }),
              ),
              InkWell(
                onTap: () {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    AppIcons.chevronRight,
                    color: AppColors.primaryMain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ExpandablePageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: List.generate(
              totalPage,
              (index) => PickupNumberPage(
                start: start + (index * 15),
                end: start + ((index + 1) * 15),
                selected: selected,
                onSelected: (value) {
                  selected = value;
                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: ButtonWidget(
              child: Text("Xác nhận",
                  style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
              onClick: () {
                Navigator.pop(context);
                widget.onSelected(selected);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PickupNumberPage extends StatelessWidget {
  const PickupNumberPage(
      {Key? key,
      required this.start,
      required this.end,
      required this.onSelected,
      this.selected})
      : super(key: key);
  final int start;
  final int end;
  final int? selected;
  final Function(int value) onSelected;

  @override
  Widget build(BuildContext context) {
    final List<int> list = List.generate(end - start, (index) => start + index);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
        crossAxisCount: 3,
        crossAxisSpacing: 32,
        mainAxisSpacing: 32,
        height: 40,
      ),
      itemCount: list.length,
      itemBuilder: (BuildContext ctx, index) {
        final item = list[index];
        return Text(
          item.toString(),
          style: AppStyles.s18w4.withColor(
              selected == item ? AppColors.primaryLight : AppColors.gray60x9d),
        ).inkWell(
          decoration: selected == item
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryMain)
              : null,
          width: 92,
          onTap: () {
            onSelected(item);
          },
        );
      },
    );
  }
}
