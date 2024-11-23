import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isTitLeftAlign;
  final bool? value;
  const CustomCheckBox(
      {super.key,
      required this.title,
      this.onTap,
      this.value,
      this.isTitLeftAlign = true});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      if (isTitLeftAlign)
        Expanded(
          child: Text(
            title.tr,
            style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyMedium?.color),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      if (isTitLeftAlign) const SizedBox(width: Dimensions.paddingSizeDefault),
      SizedBox(
        width: 20.0,
        child: Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
            value: value,
            onChanged: (bool? isActive) => onTap!()),
      ),
      if (!isTitLeftAlign) const SizedBox(width: Dimensions.paddingSizeSmall),
      if (!isTitLeftAlign)
        Expanded(
          child: Text(
            title.tr,
            style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyMedium?.color),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
    ]);
  }
}
