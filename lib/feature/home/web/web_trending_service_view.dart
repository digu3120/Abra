import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class WebTrendingServiceView extends StatelessWidget {
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const WebTrendingServiceView({super.key, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
        builder: (serviceController){

          if(serviceController.trendingServiceList != null && serviceController.trendingServiceList!.isEmpty){
            return const SizedBox();
          }else{
            if(serviceController.trendingServiceList != null){
              return  Column(
                children: [

                  const SizedBox(height: Dimensions.paddingSizeTextFieldGap),
                  TitleWidget(
                    textDecoration: TextDecoration.underline,
                    title: 'trending_services'.tr,
                    onTap: () => Get.toNamed(RouteHelper.getSearchResultRoute(fromPage: "trending")),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault,),

                  GridView.builder(
                    key: UniqueKey(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Dimensions.paddingSizeDefault,
                      mainAxisSpacing:  Dimensions.paddingSizeDefault,
                      mainAxisExtent: ResponsiveHelper.isMobile(context) ?  240 : 270 ,
                      crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 5,
                    ),
                    physics:const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: serviceController.trendingServiceList!.length>5?5:serviceController.trendingServiceList!.length,
                    itemBuilder: (context, index) {
                      return ServiceWidgetVertical(service: serviceController.trendingServiceList![index],fromType: '', signInShakeKey: signInShakeKey,);
                    },
                  )
                ],
              );
            }else{
              return const SizedBox();
            }
          }
    });
  }
}
