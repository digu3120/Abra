import 'package:demandium/feature/provider/view/nearby_provider/widget/nearby_provider_list_item_view.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class NearByProviderListView extends StatefulWidget {
  const NearByProviderListView({super.key});

  @override
  State<NearByProviderListView> createState() => _NearByProviderListViewState();
}

class _NearByProviderListViewState extends State<NearByProviderListView> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearbyProviderController>(
        builder: (nearbyProviderController) {
      return nearbyProviderController.providerList != null &&
              nearbyProviderController.providerList!.isNotEmpty
          ? PaginatedListView(
              scrollController: scrollController,
              totalSize: nearbyProviderController.providerModel?.content?.total,
              onPaginate: (int offset) async =>
                  await nearbyProviderController.getProviderList(
                offset,
                false,
              ),
              offset:
                  nearbyProviderController.providerModel?.content?.currentPage,
              itemView: Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context)
                          ? 3
                          : ResponsiveHelper.isTab(context)
                              ? 2
                              : 1,
                      mainAxisExtent:
                          ResponsiveHelper.isDesktop(context) ? 150 : 140),
                  itemCount: nearbyProviderController.providerList?.length,
                  shrinkWrap: true,
                  //physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return NearbyProviderListItemView(
                      fromHomePage: false,
                      providerData:
                          nearbyProviderController.providerList![index],
                      index: index,
                    );
                  },
                ),
              ),
              bottomPadding: 0,
            )
          : (nearbyProviderController.providerList == null)
              ? SizedBox(
                  height: ResponsiveHelper.isDesktop(context)
                      ? Get.height * 0.75
                      : Get.height * 0.9,
                  child: const ProviderListViewShimmer())
              : const EmptyProviderWidget();
    });
  }
}

class EmptyProviderWidget extends StatelessWidget {
  const EmptyProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.5,
      child: WebShadowWrap(
        maxHeight: Get.height * 0.5,
        minHeight: Get.height * 0.2,
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: Get.height * 0.05, horizontal: 20),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: Get.height * 0.4,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(300), bottom: Radius.circular(300)),
                  image: DecorationImage(
                    image: AssetImage(Images.noProviderBg),
                  )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.noProvider,
                  height: 70,
                ),
                const SizedBox(
                  height: Dimensions.paddingSizeLarge,
                ),
                Text(
                  'no_provider_found_to_your_related_filter'.tr,
                  style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .color!
                          .withOpacity(0.7)),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
