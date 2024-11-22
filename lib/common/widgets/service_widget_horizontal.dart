import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';


class ServiceWidgetHorizontal extends StatelessWidget {
  final List<Service> serviceList;
  final int index;
  final num? discountAmount;
  final String? discountAmountType;
  final bool showIsFavoriteButton;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;

  const  ServiceWidgetHorizontal({super.key,
    required this.serviceList,
    required this.index,
    required this.discountAmount,
    required this.discountAmountType,
    this.showIsFavoriteButton = true, this.signInShakeKey,
  }) ;

  @override
  Widget build(BuildContext context) {
    double lowestPrice = 0.0;
    if(serviceList[index].variationsAppFormat!.zoneWiseVariations != null){
       lowestPrice = serviceList[index].variationsAppFormat!.zoneWiseVariations![0].price!.toDouble();
      for (var i = 0; i < serviceList[index].variationsAppFormat!.zoneWiseVariations!.length; i++) {
        if (serviceList[index].variationsAppFormat!.zoneWiseVariations![i].price! < lowestPrice) {
          lowestPrice = serviceList[index].variationsAppFormat!.zoneWiseVariations![i].price!.toDouble();
        }
      }
    }
    Discount discountModel =  PriceConverter.discountCalculation(serviceList[index]);

    return Padding(
      padding:const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeEight, vertical: Dimensions.paddingSizeExtraSmall),
      child: GetBuilder<ServiceController>(builder: (serviceController){
        return OnHover(
          isItem: true,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor ,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow:  Get.find<ThemeController>().darkTheme ? null : cardShadow,
                  border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.1)),
                ),
                padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: 10),
                child: Row(children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImage(
                          image: '${serviceList[index].thumbnailFullPath}',
                          height: 100, width: 100, fit: BoxFit.cover,
                        ),
                      ),

                      discountModel.discountAmount! > 0 ? Align(alignment: Alignment.topLeft,
                        child: DiscountTagWidget(
                          discountAmount: discountModel.discountAmount,
                          discountAmountType: discountModel.discountAmountType,
                        ),
                      ) : const SizedBox(),
                    ],
                  ),

                  const SizedBox(width: Dimensions.paddingSizeSmall,),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              serviceList[index].name ?? "",
                              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraLarge,),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      RatingBar(
                        rating: double.parse(serviceList[index].avgRating.toString()), size: 15,
                        ratingCount: serviceList[index].ratingCount,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(serviceList[index].shortDescription ?? "",
                        style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("starts_from".tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5)),),

                          Column(
                              children: [
                                if(discountAmount! > 0)
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text("${PriceConverter.convertPrice(lowestPrice)} ",
                                      style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                          decoration: TextDecoration.lineThrough,
                                          color: Theme.of(context).colorScheme.error.withOpacity(.8)),
                                    ),
                                  ),

                                discountAmount! > 0?
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(PriceConverter.convertPrice(lowestPrice,
                                      discount: discountAmount!.toDouble(),
                                      discountType: discountAmountType
                                  ),
                                    style: ubuntuBold.copyWith(fontSize: Dimensions.paddingSizeDefault,
                                        color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                                  ),
                                ): Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(PriceConverter.convertPrice(lowestPrice),
                                    style: ubuntuBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Get.isDarkMode? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ]
                          ),


                        ],
                      ),
                    ]),
                  ),

                ]),
              ),
              Positioned.fill(child: RippleButton(onTap: () {
                Get.toNamed(
                  RouteHelper.getServiceRoute(serviceController.recommendedServiceList![index].id!),
                  arguments: ServiceDetailsScreen(serviceID: serviceController.recommendedServiceList![index].id!),
                );
              })),

              if(showIsFavoriteButton)Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(
                  value: serviceList[index].isFavorite,
                  onTap: (){

                    if(Get.find<AuthController>().isLoggedIn()){
                      serviceController.updateIsFavoriteStatus(
                        serviceId: serviceList[index].id!,
                        currentStatus: serviceList[index].isFavorite ?? 0,
                      );
                    }else{
                      signInShakeKey?.currentState?.shake();
                      customSnackBar(
                        "message",
                        customWidget: Row(mainAxisAlignment:  MainAxisAlignment.spaceBetween, children: [
                          const Icon(Icons.info, color:  Colors.blueAccent, size: 20),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Flexible(
                            child: Text("please_login_to_add_favorite_list".tr,
                              style: ubuntuRegular.copyWith(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          InkWell(
                            onTap : () => Get.toNamed(RouteHelper.getSignInRoute()),
                            child: Text('sign_in'.tr, style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall, color: Colors.white,
                              decoration: TextDecoration.underline,
                            )),
                          ),
                        ],),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}





