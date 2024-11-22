import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ExploreProviderItemView extends StatelessWidget {
  final ProviderData providerData;
  final int index;
  final GoogleMapController? googleMapController;
  const ExploreProviderItemView({super.key,  required this.providerData, required this.index, this.googleMapController}) ;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ExploreProviderController>(builder: (exploreProviderController){
      return Padding(padding: const EdgeInsets.all(5.0),
        child: OnHover(
          isItem: true,
          borderRadius: 15,
          child: Stack(
            children: [

              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(
                    color: exploreProviderController.selectedProviderIndex == index ?
                    Theme.of(context).colorScheme.primary.withOpacity(0.5) : Theme.of(context).hintColor.withOpacity(0.15),
                  ),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row( crossAxisAlignment: CrossAxisAlignment.start ,children: [

                    ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusExtraMoreLarge),
                      child: CustomImage(height: 60, width: 60, fit: BoxFit.cover,
                        image: providerData.logoFullPath ??"",
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(providerData.companyName ?? "", style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraLarge,)
                            ],
                          ),
                        ),

                        Padding(padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(children: [
                            RatingBar(rating: providerData.avgRating, size: 15,),
                            Gaps.horizontalGapOf(5),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child:  Text('${providerData.ratingCount} ${'reviews'.tr}', style: ubuntuRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).secondaryHeaderColor,
                              )),
                            ),
                          ],
                          ),
                        ),

                        Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Row(children: [
                            Image.asset(Images.iconLocation, height:12),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Flexible(
                                child: Text("${providerData.distance!.toStringAsFixed(2)} ${'km_away_from_you'.tr}",
                                  style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.primary ,fontSize: Dimensions.fontSizeSmall),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                          ],),
                        )
                      ],),
                    ),


                  ],),

                  const SizedBox(height: Dimensions.paddingSizeSmall,),

                  Row(children: [
                    Expanded(child: ProviderInfoButton(title: "${providerData.subscribedServicesCount}", subtitle: "services".tr,)),
                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                    Expanded(child: ProviderInfoButton(title: "${providerData.totalServiceServed}", subtitle: "services_provided".tr,)),

                  ],)

                ]),
              ),
              Positioned.fill(child: RippleButton(onTap: () async {
                if(index != exploreProviderController.selectedProviderIndex){
                  exploreProviderController.selectedProviderIndex = index;
                  exploreProviderController.update();
                  _animateCamera(googleMapController,providerData);

                  await exploreProviderController.scrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
                  await exploreProviderController.scrollController!.highlight(index);

                }else{
                  Get.toNamed(RouteHelper.getProviderDetails(providerData.id!));
                }
              }, borderRadius: 15,),),

              Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(value: providerData.isFavorite, onTap: () async {
                  if(Get.find<AuthController>().isLoggedIn()){
                    exploreProviderController.updateIsFavoriteStatus(providerId: providerData.id!, index: index);
                  }else{
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

                        TextButton(
                          onPressed: () => Get.toNamed(RouteHelper.getSignInRoute()),
                          child: Text('sign_in'.tr, style: ubuntuMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Colors.white,
                          )),
                        ),

                      ],),

                    );
                  }
                },),
              ),
            ],
          ),
        ),
      );
    });
  }

  _animateCamera(GoogleMapController? googleMapController, ProviderData providerData){
    googleMapController?.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(providerData.coordinates?.latitude ?? 23.00, providerData.coordinates?.longitude ?? 90.00), zoom: 16),
    ));
    googleMapController?.showMarkerInfoWindow(MarkerId("$index"));
  }
}





class ProviderInfoButton extends StatelessWidget {
  final String? title;
  final String subtitle;
  const ProviderInfoButton({super.key, this.title, required this.subtitle}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).hintColor.withOpacity(0.1),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall -1 ),

      child: Column(children: [
        Text("$title", style: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),),
        Text(subtitle, style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: Dimensions.fontSizeSmall)),
        const SizedBox(height: 3,)
      ],),
    );
  }
}

