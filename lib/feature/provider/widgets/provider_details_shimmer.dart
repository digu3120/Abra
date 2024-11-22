import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderDetailsShimmer extends StatelessWidget {
  const ProviderDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  SizedBox(
      width: Dimensions.webMaxWidth,
      child: Column(children: [
        Shimmer(
          child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
          ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeDefault),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                child: CustomImage(height: 70, width: 70, fit: BoxFit.cover,
                  image: "",
                  placeholder: Images.userPlaceHolder,
                ),
              ),

              const SizedBox(width: Dimensions.paddingSizeSmall,),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Container(
                    height: 22, width: screenWidth * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color:  Theme.of(context).shadowColor,
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeEight),

                  Container(
                    height: 12, width: screenWidth * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color:  Theme.of(context).shadowColor,
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(
                    height: 10, width: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color:  Theme.of(context).shadowColor,
                    ),
                  ),

                  const SizedBox(height: Dimensions.paddingSizeEight),

                  Container(
                    height: 15, width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color:  Theme.of(context).shadowColor,
                    ),
                  ),

                ],),
              )
            ],),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: ListView.separated(itemBuilder: (context,index){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 22, width: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Get.find<ThemeController>().darkTheme  ? Theme.of(context).cardColor : Theme.of(context).shadowColor,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall,),
                GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.paddingSizeDefault,
                    mainAxisSpacing:  Dimensions.paddingSizeDefault,
                    mainAxisExtent: ResponsiveHelper.isDesktop(context) ?  270 : 240 ,
                    crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
                  ),
                  physics:  const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
                  itemBuilder: (context, index) {
                    return const ServiceShimmer(isEnabled: true, hasDivider: false);
                  },
                ),
              ],
            );
          },
            itemCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Divider(color: Theme.of(context).hintColor),
              );
            },
          ),
        )
      ]),
    );
  }
}
