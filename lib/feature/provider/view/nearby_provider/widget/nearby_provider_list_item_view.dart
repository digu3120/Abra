import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class NearbyProviderListItemView extends StatelessWidget {
  final bool fromHomePage;
  final ProviderData providerData;
  final GlobalKey<CustomShakingWidgetState>? signInShakeKey;
  final int index;
  const NearbyProviderListItemView(
      {super.key,
      this.fromHomePage = true,
      required this.providerData,
      required this.index,
      this.signInShakeKey});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearbyProviderController>(
        builder: (providerBookingController) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isDesktop(context) && fromHomePage
                ? 5
                : Dimensions.paddingSizeEight,
            vertical: fromHomePage ? 0 : Dimensions.paddingSizeEight),
        child: OnHover(
          isItem: true,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(
                      color: Theme.of(context).hintColor.withOpacity(0.3)),
                ),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.radiusExtraMoreLarge),
                              child: Stack(children: [
                                CustomImage(
                                  height: 70,
                                  width: 70,
                                  fit: BoxFit.cover,
                                  image: providerData.logoFullPath ?? "",
                                  placeholder: Images.userPlaceHolder,
                                ),
                                if (providerData.serviceAvailability == 0)
                                  Positioned.fill(
                                      child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text('unavailable'.tr,
                                            style: ubuntuLight.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall - 1,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                  ))
                              ]),
                            ),
                            const SizedBox(
                                width: Dimensions.paddingSizeDefault),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(children: [
                                      Flexible(
                                        child: Text(
                                          providerData.companyName ?? "",
                                          style: ubuntuMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault +
                                                      1),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: Dimensions.paddingSizeExtraLarge,
                                      )
                                    ]),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          child: Row(children: [
                                            Image(
                                              image:
                                                  AssetImage(Images.starIcon),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            Gaps.horizontalGapOf(3),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Text(
                                                providerData.avgRating!
                                                    .toStringAsFixed(2),
                                                style: ubuntuRegular.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color
                                                        ?.withOpacity(0.6),
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        Gaps.horizontalGapOf(5),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            "(${providerData.ratingCount})",
                                            style: ubuntuRegular.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color
                                                    ?.withOpacity(0.6),
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                      providerData.companyAddress ?? "",
                                      style: ubuntuRegular.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color
                                              ?.withOpacity(0.6),
                                          fontSize: Dimensions.fontSizeSmall),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeTine),
                                    Row(
                                      children: [
                                        Image.asset(Images.distance,
                                            height: 12),
                                        const SizedBox(
                                            width: Dimensions
                                                .paddingSizeExtraSmall),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Flexible(
                                            child: Text(
                                              "${providerData.distance!.toStringAsFixed(2)} ${'km_away_from_you'.tr}",
                                              style: ubuntuMedium.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                            ),
                          ]),
                    ]),
              ),
              Positioned.fill(child: RippleButton(onTap: () {
                Get.toNamed(RouteHelper.getProviderDetails(providerData.id!));
              })),
              Align(
                alignment: favButtonAlignment(),
                child: FavoriteIconWidget(
                  value: providerData.isFavorite,
                  providerId: providerData.id,
                  signInShakeKey: signInShakeKey,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
