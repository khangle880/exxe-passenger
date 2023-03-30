import '../../../../utils/export/ui_export.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage(
      {Key? key,
      this.url,
      this.host = "",
      this.decoration,
      this.size,
      this.width,
      this.height,
      this.placeholderText = "error",
      this.margin,
      this.fit = BoxFit.cover,
      this.padding,
      this.errorImage})
      : assert(size != null || height != null || width != null),
        super(key: key);

  final String? url;
  final String host;
  final double? size;
  final double? width;
  final double? height;
  final String placeholderText;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? errorImage;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    String link = url ?? "";
    link = Uri.parse(link).isAbsolute ? link : host + link;
    return Container(
      width: width ?? size,
      height: height ?? size,
      decoration: decoration ?? const BoxDecoration(shape: BoxShape.circle),
      margin: margin,
      padding: padding,
      child: (url ?? "").isNotEmpty && Uri.parse(link).isAbsolute
          ? CachedNetworkImage(
              fit: fit,
              imageUrl: link,
              placeholder: (context, url) => Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: (size ?? 40) / 2,
                    width: (size ?? 40) / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              imageBuilder: (context, imageProvider) => Container(
                decoration: decoration?.copyWith(
                      image: DecorationImage(image: imageProvider, fit: fit),
                    ) ??
                    BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: fit,
                      ),
                    ),
              ),
              errorWidget: (context, url, error) => errorImage ??
                  SvgPicture.asset(
                    AppIcons.imagePicker,
                    color: AppColors.gray60,
                    width: size,
                    height: size,
                  ),
            )
          : errorImage ??
              SvgPicture.asset(
                AppIcons.imagePicker,
                color: AppColors.gray60,
                width: size,
                height: size,
              ),
    );
  }
}
