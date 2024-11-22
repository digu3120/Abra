import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {

      return categoryController.categoryList != null && categoryController.categoryList!.isEmpty ? const SizedBox() :
      categoryController.categoryList != null ? Center(
        child: SizedBox(width: Dimensions.webMaxWidth,
          child: Padding(padding: const EdgeInsets.symmetric( vertical:Dimensions.paddingSizeDefault),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              TitleWidget(
                textDecoration: TextDecoration.underline,
                title: 'all_categories'.tr,
                onTap: (categoryController.categoryList!.length > 8 && ResponsiveHelper.isMobile(context))
                    || (categoryController.categoryList!.length > 12 && ResponsiveHelper.isTab(context))
                    || (categoryController.categoryList!.length > 10 && ResponsiveHelper.isDesktop(context))
                    ? () => Get.toNamed(RouteHelper.getCategoryProductRoute(
                  categoryController.categoryList![0].id!,
                  categoryController.categoryList![0].name!,
                  0.toString(),
                )) : null,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.isDesktop(context) ? 10 : ResponsiveHelper.isTab(context) ? 6 : 4,
                  crossAxisSpacing: Dimensions.paddingSizeSmall,
                  mainAxisSpacing: Dimensions.paddingSizeSmall,
                  childAspectRatio: 1,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ResponsiveHelper.isDesktop(context) && categoryController.categoryList!.length > 10 ? 10
                    : ResponsiveHelper.isTab(context) &&  categoryController.categoryList!.length > 12 ? 12
                    : ResponsiveHelper.isMobile(context) &&  categoryController.categoryList!.length > 8 ? 8
                    : categoryController.categoryList!.length,
                itemBuilder: (context, index) {
                  return TextHover(builder: (hovered){
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:  Get.find<ThemeController>().darkTheme ? Theme.of(context).cardColor : Theme.of(context).colorScheme.primary.withOpacity(hovered ? 0.1 : 0.06),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault), ),
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.center, children: [

                            SizedBox(height: (ResponsiveHelper.isMobile(context) || ( kIsWeb && hovered) ) ?  Dimensions.paddingSizeSmall + 3 : Dimensions.paddingSizeDefault,),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric( horizontal :  Dimensions.paddingSizeDefault),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  child: CustomImage(
                                    image: categoryController.categoryList![index].imageFullPath ?? "",
                                    fit: BoxFit.fitHeight, height: double.infinity, width:  double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: (ResponsiveHelper.isMobile(context) || ( kIsWeb && hovered) ) ?  Dimensions.paddingSizeSmall + 3 : Dimensions.paddingSizeDefault,),

                            Padding(padding: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeExtraSmall),
                              child: Text(categoryController.categoryList![index].name!,
                                style: ubuntuRegular.copyWith(
                                  fontSize: MediaQuery.of(context).size.width<300?Dimensions.fontSizeExtraSmall:Dimensions.fontSizeSmall,
                                  color: hovered ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color,
                                ),
                                maxLines: MediaQuery.of(context).size.width<300?1:2,textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeEight,)

                          ]),
                        ),
                        Positioned.fill(child: RippleButton(onTap: (){
                          Get.toNamed(RouteHelper.getCategoryProductRoute(
                            categoryController.categoryList![index].id!, categoryController.categoryList![index].name!,
                            index.toString(),
                          ));
                        }))
                      ],
                    );
                  });
                },
              ) ,
            ]),
          ),
        ),
      ) : const CategoryShimmer();
    });
  }
}



class CategoryShimmer extends StatelessWidget {
  final bool? fromHomeScreen;

  const CategoryShimmer({super.key, this.fromHomeScreen=true});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Column(
          children: [
            if(fromHomeScreen!) const SizedBox(height: Dimensions.paddingSizeLarge,),
            if(fromHomeScreen!) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 25, width: 120,
                  decoration: BoxDecoration(
                    color: Get.find<ThemeController>().darkTheme ?  Theme.of(context).cardColor : Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: Get.isDarkMode ? null : cardShadow,
                  ),
                ), Container(
                  height: 25, width: 100,
                  decoration: BoxDecoration(
                    color: Get.find<ThemeController>().darkTheme ?  Theme.of(context).cardColor : Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: Get.isDarkMode ? null : cardShadow,
                  ),
                ),
            ],),
            if(fromHomeScreen!)const SizedBox(height: Dimensions.paddingSizeSmall,),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:  !fromHomeScreen! ? 8 : ResponsiveHelper.isDesktop(context) ? 10 : ResponsiveHelper.isTab(context)? 12 : 8,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: Get.isDarkMode ? null: cardShadow,
                  ),
                  child: Shimmer(
                    duration: const Duration(seconds: 2),
                    enabled: true,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [

                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).shadowColor,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeDefault),
                    ]),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: !fromHomeScreen! ? 8 : ResponsiveHelper.isDesktop(context) ? 10 : ResponsiveHelper.isTab(context) ? 6 : 4,
                crossAxisSpacing: Dimensions.paddingSizeSmall + 2,
                mainAxisSpacing: Dimensions.paddingSizeSmall + 2,
                childAspectRatio: 1,
              ),
            ),

            SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge,)
          ],
        ),
      ),
    );
  }
}
