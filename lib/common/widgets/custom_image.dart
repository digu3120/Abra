import 'package:demandium/utils/core_export.dart';

class CustomImage extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final BoxFit? placeHolderBoxFit;
  final String? placeholder;
  const CustomImage({super.key, @required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder, this.placeHolderBoxFit });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image! , height: height, width: width, fit: fit,
      placeholder: (context, url) => Image.asset(placeholder ?? Images.placeholder, height: height, width: width, fit: placeHolderBoxFit ?? fit),
      errorWidget: (context, url, error) => Image.asset(placeholder ?? Images.placeholder, height: height, width: width, fit: placeHolderBoxFit ?? fit),
    );
  }
}
