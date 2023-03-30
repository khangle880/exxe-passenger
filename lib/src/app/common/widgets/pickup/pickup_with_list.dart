import 'package:exxe/src/data/data.dart';

import '../../../../utils/export/ui_export.dart';

class PickupWithList<T> extends StatefulWidget {
  const PickupWithList({
    Key? key,
    required this.list,
    this.padding = EdgeInsets.zero,
    required this.onSelected,
    required this.getName,
    required this.title,
  }) : super(key: key);
  final List<T>? list;
  final EdgeInsets padding;
  final Function(T item) onSelected;
  final String Function(T item) getName;
  final String title;

  @override
  State<PickupWithList<T>> createState() => _PickupWithListState<T>();
}

class _PickupWithListState<T> extends State<PickupWithList<T>> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (widget.list == null) {
      body = const Center(
          child: SizedBox(
              height: 30, width: 30, child: CircularProgressIndicator()));
    } else if (widget.list!.isEmpty) {
      body = Text("Không có địa điểm nào phù hợp", style: AppStyles.s16w6);
    } else {
      body = ListView(
        padding: widget.padding,
        children: widget.list!
            .map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    e.runtimeType == BankModel
                        ? Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: CustomNetworkImage(
                              size: 24,
                              decoration: const BoxDecoration(
                                color: AppColors.gray20,
                                shape: BoxShape.rectangle,
                              ),
                              fit: BoxFit.fill,
                              host: Apis.baseUrl,
                              url: (e as BankModel).imageModel?.urlBankIcon,
                              errorImage: const Icon(
                                Icons.image_outlined,
                                size: 24,
                                color: Colors.black12,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Expanded(
                      child: InkWell(
                        onTap: () => widget.onSelected(e),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            widget.getName(e),
                            style:
                                AppStyles.s14w4.withColor(AppColors.gray70x76),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );
    }

    return Column(
      children: [
        Container(
          padding: widget.padding,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: AppStyles.s16w7.withColor(AppColors.gray95x06),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: body),
      ],
    );
  }
}
