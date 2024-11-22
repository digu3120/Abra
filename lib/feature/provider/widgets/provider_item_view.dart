import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderItemView extends StatelessWidget {
  final  bool fromHomePage;
  final ProviderData providerData;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final int index;
  const ProviderItemView({super.key, this.fromHomePage = true, required this.providerData, required this.index, this.signInShakeKey}) ;

  @override
  Widget build(BuildContext context) {
    List<String> subcategory=[];
    providerData.subscribedServices?.forEach((element) {
      if(element.subCategory!=null){
        subcategory.add(element.subCategory?.name??"");
      }
    });

    String subcategories = subcategory.toString().replaceAll('[', '');
    subcategories = subcategories.replaceAll(']', '');
    subcategories = subcategories.replaceAll('&', ' and ');

    return GetBuilder<ProviderBookingController>(builder: (providerBookingController){
      return Padding(padding:EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context) && fromHomePage ? 5 : Dimensions.paddingSizeEight,
          vertical: fromHomePage?0:Dimensions.paddingSizeEight),

        child: OnHover(
          isItem: true,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center,children: [

                    ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                      child: CustomImage(height: 65, width: 65, fit: BoxFit.cover,
                        image: providerData.logoFullPath ?? "" , placeholder: Images.userPlaceHolder,
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,children: [
                        Row(children: [
                          Flexible(
                            child: Text(providerData.companyName??"", style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                              maxLines: 2, overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraLarge,)
                        ]),

                        Row(children: [
                          RatingBar(rating: providerData.avgRating),
                          Gaps.horizontalGapOf(5),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child:  Text('${providerData.ratingCount} ${'reviews'.tr}', style: ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).secondaryHeaderColor,
                            )),
                          ),
                        ],
                        ),
                      ],),
                    ),
                  ],),

                  (subcategories.isNotEmpty) ? Padding( padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                    child: Text(subcategories,
                      style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).secondaryHeaderColor), maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ): const SizedBox(height: Dimensions.paddingSizeSmall,),

                  Row(children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      child: Image.asset(Images.iconLocation, height:12,),
                    ),

                    Flexible(
                      child: Text(providerData.companyAddress??"",
                        style: ubuntuMedium.copyWith(color:Get.isDarkMode? Theme.of(context).secondaryHeaderColor:Theme.of(context).primaryColorDark,fontSize: Dimensions.fontSizeSmall),
                        overflow: TextOverflow.ellipsis, maxLines: 1,
                      ),
                    ),

                  ],)
                ]),
              ),

              Positioned.fill(child: RippleButton(onTap: () {
                Get.toNamed(RouteHelper.getProviderDetails(providerData.id!));
              })),

              Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(
                  value: providerData.isFavorite,
                  onTap: (){
                    if(Get.find<AuthController>().isLoggedIn()){
                      providerBookingController.updateIsFavoriteStatus(providerId: providerData.id!, index: index);
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
        ),
      );
    });
  }
}