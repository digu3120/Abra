import 'package:demandium/feature/provider/view/nearby_provider/widget/nearby_provider_list_item_view.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class NearbyProviderListview extends StatelessWidget {
  final double height;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  const NearbyProviderListview({super.key, required this.height, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearbyProviderController>(
        builder: (providerBookingController){
          return providerBookingController.providerList != null && providerBookingController.providerList!.isNotEmpty ? Container(
            color: Get.isDarkMode ? Colors.grey.shade900 : Theme.of(context).primaryColor.withOpacity(0.12),
            height: height,
            child: Stack(children: [
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Column(children: [
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 15, Dimensions.paddingSizeDefault,  Dimensions.paddingSizeSmall,),
                    child: TitleWidget(
                      textDecoration: TextDecoration.underline,
                      title:'providers_near_you'.tr,
                      onTap: () => Get.toNamed(RouteHelper.getNearByProviderScreen(tabIndex: 0)),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.isMobile(context) ? 140 : 150,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall + 2),
                      itemCount: providerBookingController.providerList?.length,
                      itemBuilder: (context, index){
                        return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                          child: SizedBox(
                            width: ResponsiveHelper.isDesktop(context) ? Dimensions.webMaxWidth / 3.2 : ResponsiveHelper.isTab(context)? Get.width/ 2.5 :  Get.width/1.16,
                            child: NearbyProviderListItemView(providerData: providerBookingController.providerList![index], index: index, signInShakeKey: signInShakeKey,),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              )
            ],
            ),
          ) :  providerBookingController.providerList != null && providerBookingController.providerList!.isEmpty ? const SizedBox() :
          HomeRecommendedProviderShimmer(height: height,);

        });
  }
}