import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class ProviderReviewScreen extends StatefulWidget {
  final String? providerId;
  const ProviderReviewScreen({super.key,this.providerId}) ;

  @override
  State<ProviderReviewScreen> createState() => _ProviderReviewScreenState();
}

class _ProviderReviewScreenState extends State<ProviderReviewScreen> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<ProviderBookingController>().getProviderDetailsData(widget.providerId ?? "", false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'provider_review'.tr),
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      body: GetBuilder<ProviderBookingController>(builder: (providerBookingController){

        List<String> subcategory=[];
        providerBookingController.providerDetailsContent?.subCategories?.forEach((element) {
          subcategory.add(element.name ?? "");
        });

        String subcategories = subcategory.toString().replaceAll('[', '');
        subcategories = subcategories.replaceAll(']', '');
        subcategories = subcategories.replaceAll('&', ' and ');

        return FooterBaseView(
          isScrollView: true,
          child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: providerBookingController.providerDetailsContent!=null ?
            Column(children: [

              if(providerBookingController.providerDetailsContent?.provider?.serviceAvailability == 0)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.error))
                ),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
                child: Center(child: Text('provider_is_currently_unavailable'.tr, style: ubuntuMedium,)),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(Dimensions.radiusDefault),
                    bottomRight: Radius.circular(Dimensions.radiusDefault),
                  ),
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: ResponsiveHelper.isDesktop(context) ? Row(
                  children: [
                    Expanded(child: ProviderDetailsTopCard(
                      isAppbar: false,subcategories: subcategories,providerId: widget.providerId ?? "",
                      color: Theme.of(context).primaryColor.withOpacity(0.00),
                    )),
                    Expanded(child: ReviewRatingWidget(providerBookingController: providerBookingController,))
                  ],
                ) : Column(children: [
                  ProviderDetailsTopCard(isAppbar: false,subcategories: subcategories ,providerId: widget.providerId ?? "",),
                  ReviewRatingWidget(providerBookingController: providerBookingController,)
                ]),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall,),

              providerBookingController.providerDetailsContent!.providerReview!= null && providerBookingController.providerDetailsContent!.providerReview!.reviewList!.isNotEmpty ?
              WebShadowWrap(
                shadow: lightShadow,
                child: PaginatedListView(
                  scrollController: scrollController,
                  totalSize: providerBookingController.providerDetailsContent!.providerReview!.total,
                  onPaginate: (int offset) async => await providerBookingController.getProviderDetailsData(widget.providerId ?? "", true, offSet: offset),
                  offset: providerBookingController.providerDetailsContent!.providerReview!.currentPage,
                  itemView: ListView.builder(
                    padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    itemBuilder: (context, index){
                      return ServiceReviewItem(review: providerBookingController.reviewList![index],
                      );
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: providerBookingController.reviewList?.length,
                  ),
                ),
              ) :  SizedBox(height: Get.height*.4,child: const Center(child: EmptyReviewWidget())),


            ],
            ) : const Center(child: CircularProgressIndicator()),
          ),
        );
      }),
    );
  }
}

class ReviewRatingWidget extends StatelessWidget {
  final ProviderBookingController providerBookingController;

  const ReviewRatingWidget(
      {super.key, required this.providerBookingController});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme
            .of(context)
            .cardColor,
      ),
      margin: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Column(children: [
        Image.asset(Images.reviewIcon, width: 60,),
        Padding(padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall),
          child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                providerBookingController.providerDetailsContent!.provider!
                    .avgRating!.toStringAsFixed(2),
                style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeOverLarge, color: Theme
                    .of(context)
                    .colorScheme
                    .primary),)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${providerBookingController.providerDetailsContent!.provider!
                  .ratingCount ?? ""} ${'ratings'.tr}",
              style: ubuntuMedium.copyWith(color: Theme
                  .of(context)
                  .secondaryHeaderColor, fontSize: Dimensions.fontSizeSmall),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Text("${providerBookingController.providerDetailsContent!.providerRating!.reviewCount ?? ""} ${'reviews'.tr}",
              style: ubuntuMedium.copyWith(color: Theme
                  .of(context)
                  .secondaryHeaderColor, fontSize: Dimensions.fontSizeSmall),
            ),
          ],
        ),
      ]),
    );

  }
}