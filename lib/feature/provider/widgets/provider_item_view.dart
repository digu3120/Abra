import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderItemView extends StatelessWidget {
  final bool fromHomePage;
  final ProviderData providerData;
  final GlobalKey<CustomShakingWidgetState>? signInShakeKey;
  final int index;
  const ProviderItemView(
      {super.key,
      this.fromHomePage = true,
      required this.providerData,
      required this.index,
      this.signInShakeKey});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderBookingController>(
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
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.radiusExtraMoreLarge),
                            child: CustomImage(
                              height: 65,
                              width: 65,
                              fit: BoxFit.cover,
                              image: providerData.logoFullPath ?? "",
                              placeholder: Images.userPlaceHolder,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
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
                                          fontSize: Dimensions.fontSizeLarge),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Dimensions.paddingSizeExtraLarge,
                                  )
                                ]),
                                Row(
                                  children: [
                                    RatingBar(rating: providerData.avgRating),
                                    Gaps.horizontalGapOf(5),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                          '${providerData.ratingCount} ${'reviews'.tr}',
                                          style: ubuntuRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text(
                        providerData.companyAddress ?? "",
                        style: ubuntuRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(0.7)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeTine),
                      Row(children: [
                        Image.asset(
                          Images.distance,
                          height: 12,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Flexible(
                          child: Text(
                            "${providerData.distance!.toStringAsFixed(2)} ${'km_away_from_you'.tr}",
                            style: ubuntuMedium.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ])
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
