import 'package:demandium/common/widgets/ldashed_line_printer.dart';
import 'package:get/get.dart';
import 'package:demandium/feature/review/controller/submit_review_controller.dart';
import 'package:demandium/feature/review/widgets/select_rating.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:readmore/readmore.dart';

class RateReviewScreen extends StatefulWidget{
  final String? id;
  const RateReviewScreen({super.key, this.id}) ;

  @override
  State<RateReviewScreen> createState() => _RateReviewScreenState();
}
class _RateReviewScreenState extends State<RateReviewScreen> {

  _loadData() async {
   if(widget.id !=null){
     Get.find<BookingDetailsController>().getBookingDetails(bookingId: widget.id!);
     await Get.find<SubmitReviewController>().getReviewList(widget.id!);
   }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title: 'review'.tr,),
      body: GetBuilder<BookingDetailsController>(builder: (bookingController){
        if(widget.id == null){
          return const NoDataScreen(text: "no_data_found", type: NoDataType.bookings,);
        } else if(bookingController.bookingDetailsContent!=null){
         return GetBuilder<SubmitReviewController>(builder: (submitReviewController){
           if(submitReviewController.loading){
             return const Center(child: CircularProgressIndicator(),);
           }else{
             return FooterBaseView(
               child: SizedBox(
                 width: Dimensions.webMaxWidth,
                 child: SingleChildScrollView(
                   child: Column(
                     children: [
                       Stack(children: [
                         Container(
                           height:ResponsiveHelper.isDesktop(context)? 280: 120.0,
                           width: Get.width,
                           decoration: BoxDecoration(
                               image: DecorationImage(fit: BoxFit.fill, image: AssetImage(Images.reviewTopBanner))
                           ),),
                         SizedBox(
                           height:ResponsiveHelper.isDesktop(context)? 280: 120.0,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               ResponsiveHelper.isDesktop(context)?Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: ReviewBookingDetailsCard(bookingDetailsContent: bookingController.bookingDetailsContent!),
                               ):const SizedBox(),
                             ],
                           ),
                         )
                       ],),

                       const SizedBox(height: Dimensions.paddingSizeLarge,),
                       !ResponsiveHelper.isDesktop(context)
                           ? ReviewBookingDetailsCard(bookingDetailsContent: bookingController.bookingDetailsContent!):const SizedBox(),

                       ListView.builder(itemBuilder: (context,index) {

                         List<String> variationList=[];
                         Get.find<BookingDetailsController>().bookingDetailsContent!.detail?.forEach((bookingDetailsItem) {
                           if(submitReviewController.serviceReviewList?[index].id ==bookingDetailsItem.serviceId){
                             variationList.add(bookingDetailsItem.variantKey??"");
                           }
                         });
                         String variations = variationList.toString().replaceAll('[', '');
                         variations = variations.replaceAll(']', '');

                         return Padding(
                           padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault),
                           child: submitReviewController.isEditable[submitReviewController.serviceReviewList![index].id!]!
                               ? EditableReview(serviceReview: submitReviewController.serviceReviewList?[index], index: index, variations: variations, bookingId: widget.id,)
                               : NonEditableReview(serviceReview: submitReviewController.serviceReviewList?[index], index: index, variations: variations),
                         );
                       },
                         shrinkWrap: true,
                         physics: const NeverScrollableScrollPhysics(),
                         itemCount:submitReviewController.serviceReviewList?.length,
                       ),

                       const SizedBox(height: Dimensions.paddingSizeExtraLarge,)

                     ],
                   ),
                 ),
               ),
             );
           }
         }
         );
       }else{
         return const Center(child: CircularProgressIndicator(),);
       }
      }
      ),
    );
  }
}

class ReviewBookingDetailsCard extends StatelessWidget {
  const ReviewBookingDetailsCard({
    super.key,
    required this.bookingDetailsContent,
  }) ;
  final BookingDetailsContent bookingDetailsContent;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeSmall),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${'booking_no'.tr} # ${bookingDetailsContent.readableId}",
                style: ubuntuBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).colorScheme.primary),),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                    PriceConverter.convertPrice(bookingDetailsContent.totalBookingAmount!.toDouble()),
                    style: ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge!.color
                    )
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  DateConverter.formatDate(DateConverter.isoUtcStringToLocalDate(bookingDetailsContent.createdAt!)),
                  style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)
                  ),
              ),
              Text("${bookingDetailsContent.bookingStatus}".tr, style: ubuntuMedium.copyWith(color: Colors.green),),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall,)
        ],

      ),
    );
  }
}

class EditableReview extends StatefulWidget {
 final Service? serviceReview;
 final int index;
 final String variations;
 final String? bookingId;
  const EditableReview({super.key,this.serviceReview, required this.index, required this.variations, this.bookingId}) ;

  @override
  State<EditableReview> createState() => _EditableReviewState();
}

class _EditableReviewState extends State<EditableReview> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<SubmitReviewController>(builder: (submitReviewController){

      return Column(
        children: [
          const SizedBox(height: Dimensions.paddingSizeDefault,),
          Text( widget.serviceReview?.name ?? "",
            style: ubuntuMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
          Text(
            widget.variations,
            style: ubuntuRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              SelectRating(revivedId: widget.serviceReview!.id!,),
              const SizedBox()
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                color: Theme.of(context).hoverColor),
            child: Center(
              child: TextFormField(maxLines: 4,
                controller: submitReviewController.textControllers[widget.serviceReview!.id!],
                decoration: InputDecoration(
                  hintText: 'write_your_review'.tr,
                  border: InputBorder.none,
                  hintStyle: ubuntuRegular,
                ),
              ),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault,),
          CustomButton(
            height: ResponsiveHelper.isDesktop(context) ? 45 : 40,
            width: ResponsiveHelper.isDesktop(context) ? 200:ResponsiveHelper.isTab(context)?150:120,
            radius: 50,
            isLoading: submitReviewController.selectedIndex== widget.index && submitReviewController.isLoading,
            buttonText: 'submit'.tr,
            onPressed: (){
              String review =  submitReviewController.textControllers[widget.serviceReview!.id!]!.value.text;
              if(isRedundentClick(DateTime.now())){
                return;
              }
              submitReviewController.setIndex(widget.index);
              ReviewBody  reviewBody = ReviewBody(
                bookingID: widget.bookingId ?? "",
                serviceID: widget.serviceReview!.id!,
                rating: submitReviewController.selectedRating[widget.serviceReview!.id!].toString(),
                comment: review,
              );
              submitReviewController.submitReview(reviewBody,  widget.serviceReview!.id!, review, widget.index );

            },
          )
        ],
      );
    });
  }
}


class NonEditableReview extends StatelessWidget {
  final Service? serviceReview;
  final int index;
  final String variations;
  const NonEditableReview({super.key, this.serviceReview, required this.index, required this.variations}) ;

  @override
  Widget build(BuildContext context) {

    String? reviewReply;
    String updatedAt = "";
    if(serviceReview!=null && serviceReview!.review !=null && serviceReview!.review!.isNotEmpty && serviceReview!.review!.first.reviewReply != null){
      reviewReply = serviceReview?.review?.first.reviewReply?.reply;
      updatedAt = serviceReview!.review!.first.reviewReply!.updatedAt!;
    }
    return  GetBuilder<SubmitReviewController>(builder: (submitReviewController){
      return Stack(
          children:[
            Column(
              children: [
                const SizedBox(height: Dimensions.paddingSizeDefault,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( serviceReview?.name ?? "",
                      style: ubuntuMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),

                    const SizedBox(width: Dimensions.paddingSizeSmall,),

                    Image.asset(Images.accepted,width: 15,),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                Text(
                  variations,
                  style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    SelectRating(revivedId: serviceReview!.id!, clickable: false,),
                    const SizedBox()
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall,),
                submitReviewController.reviewComments[serviceReview!.id]!.isNotEmpty ? Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReadMoreText(
                        submitReviewController.reviewComments[serviceReview!.id] ?? "",
                        trimCollapsedText : "see_more".tr,
                        trimExpandedText: "  ${"see_less".tr}",
                        trimMode: TrimMode.Line,
                        trimLines: 3,
                        style: ubuntuRegular.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                            fontSize: Dimensions.fontSizeSmall,
                            height: 1.5
                        ),
                        textAlign: TextAlign.justify,
                        moreStyle: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),
                        lessStyle: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                      if(reviewReply !=null && submitReviewController.reviewComments[serviceReview!.id]!.isNotEmpty) Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeEight),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(width: Dimensions.paddingSizeEight,),
                          CustomPaint(
                            size: const Size(20, 50), // Adjust size as needed
                            painter: LDashedLinePainter(),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).cardColor,
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        Image.asset(Images.reviewReply, width: 25,),
                                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                                        Text("replied_by_provider".tr, style: ubuntuRegular,),
                                      ]),

                                      Text(DateConverter.dateStringMonthYear(DateConverter.isoUtcStringToLocalDate(updatedAt)),
                                        style: ubuntuRegular.copyWith(color:  Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall + 1),
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                                  ReadMoreText(
                                    reviewReply,
                                    trimCollapsedText : "see_more".tr,
                                    trimExpandedText: "  ${"see_less".tr}",
                                    trimMode: TrimMode.Line,
                                    trimLines: 3,
                                    style: ubuntuRegular.copyWith(
                                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                                        fontSize: Dimensions.fontSizeSmall,
                                        height: 1.5
                                    ),
                                    textAlign: TextAlign.justify,
                                    moreStyle: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),
                                    lessStyle: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],),
                      ),
                    ],
                  ),
                ) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
              ],
            ),
            Get.find<LocalizationController>().isLtr ? Positioned(
                right: 0, child: IconButton(
                onPressed:() {
                  Get.find<SubmitReviewController>().updateEditableValue(serviceReview!.id!, true,isUpdate: true);}, icon: Image.asset(Images.edit,width: 15,)
            )): Positioned(left: 0,
              child: IconButton(
                  onPressed:() {
                    Get.find<SubmitReviewController>().updateEditableValue(serviceReview!.id!, true,isUpdate: true);
                  }, icon: Image.asset(Images.edit,width: 15,)
              ),
            ),
          ]
      );
    });
  }
}

