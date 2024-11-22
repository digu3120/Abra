import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class ServiceShimmer extends StatelessWidget {
  final bool? isEnabled;
  final bool? hasDivider;
  const ServiceShimmer({super.key, required this.isEnabled, required this.hasDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow:  Get.find<ThemeController>().darkTheme ? null : cardShadow,
      ),
      margin: const EdgeInsets.only(top: 5),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        enabled: isEnabled!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:  Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(10),

                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Container(height: 15, width: double.maxFinite,
              decoration: BoxDecoration(
                color:  Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              height:  10, width: double.maxFinite,
              decoration: BoxDecoration(
                color:  Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Container(
              height:  10, width: double.maxFinite,
              decoration: BoxDecoration(
                color:  Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge * 2),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Row(children: [
              Container(height:10, width: 30, color:  Theme.of(context).shadowColor),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
              Container(height: 10, width: 20, color: Theme.of(context).shadowColor),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall,),
          ],
        ),
      ),
    );
  }
}
