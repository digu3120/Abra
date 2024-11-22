import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class FeatheredCategoryView extends StatefulWidget {
  const FeatheredCategoryView({super.key}) ;

  @override
  State<FeatheredCategoryView> createState() => _FeatheredCategoryViewState();
}

class _FeatheredCategoryViewState extends State<FeatheredCategoryView> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(builder: (serviceController){

      return serviceController.categoryList == null ? const SizedBox() :

       SizedBox(
        height: serviceController.categoryList!.length * 330,
        child: ListView.builder(itemBuilder: (context,categoryIndex){

          int serviceItemCount;
          serviceItemCount = serviceController.categoryList![categoryIndex].servicesByCategory!.length > 5 ? 5
                : serviceController.categoryList![categoryIndex].servicesByCategory!.length;

          return  Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
            ),
            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: 0),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeSmall,
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeExtraSmall,
                  ),
                  child: TitleWidget(
                    textDecoration: TextDecoration.underline,
                    title: serviceController.categoryList?[categoryIndex].name??"",
                    onTap: () =>  Get.toNamed(RouteHelper.getFeatheredCategoryService(
                        serviceController.categoryList?[categoryIndex].name??"", serviceController.categoryList?[categoryIndex].id ?? ""),
                    ),
                  ),
                ),

                SizedBox(
                  height: 255,
                  width: Get.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault,bottom: Dimensions.paddingSizeExtraSmall,top: Dimensions.paddingSizeExtraSmall),
                    itemCount: serviceItemCount,
                    itemBuilder: (context, index) {
                      return Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall + 2),
                        child: SizedBox(
                           width: ResponsiveHelper.isTab(context) ? 250 : Get.width / 2.30,
                            child: ServiceWidgetVertical(service: serviceController.categoryList![categoryIndex].servicesByCategory![index],
                          fromType: '',
                        )
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall)
              ],
            ),
          );
        },itemCount: serviceController.categoryList?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
        ),
      );
    });
  }
}
