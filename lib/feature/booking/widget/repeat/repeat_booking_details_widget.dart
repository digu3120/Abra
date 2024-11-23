import 'package:demandium/feature/booking/view/repeat_booking_details_screen.dart';
import 'package:demandium/feature/booking/view/web_booking_details_screen.dart';
import 'package:demandium/feature/booking/widget/booking_photo_evidence.dart';
import 'package:demandium/feature/booking/widget/booking_screen_shimmer.dart';
import 'package:demandium/feature/booking/widget/repeat/all_booking_summary_widget.dart';
import 'package:demandium/feature/booking/widget/repeat/next_service_widget.dart';
import 'package:demandium/feature/booking/widget/repeat/repeat_booking_info_widget.dart';
import 'package:demandium/feature/booking/widget/repeat/repeat_booking_summary_widget.dart';
import 'package:demandium/feature/booking/widget/repeat/schedule_widget.dart';
import 'package:demandium/helper/booking_helper.dart';
import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:demandium/feature/booking/widget/provider_info.dart';
import 'package:demandium/feature/booking/widget/service_man_info.dart';


class RepeatBookingDetailsWidget extends StatelessWidget {
  final TabController? tabController;
  const RepeatBookingDetailsWidget({super.key, this.tabController}) ;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>( builder: (bookingDetailsTabController) {

      BookingDetailsContent? bookingDetails =  bookingDetailsTabController.bookingDetailsContent;

      if(bookingDetails != null){
        String bookingStatus = bookingDetails.bookingStatus ?? "";
        bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
        RepeatBooking ? nextBooking = BookingHelper.getNextUpcomingRepeatBooking(bookingDetails);

        return SingleChildScrollView(physics: const ClampingScrollPhysics(), child: Column( children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 :  Dimensions.paddingSizeDefault),
            child: Column( mainAxisSize: MainAxisSize.min, children: [

              ResponsiveHelper.isDesktop(context) ? BookingDetailsTopCard(bookingDetailsContent: bookingDetails) : const SizedBox(),
              RepeatBookingTabBar(tabController: tabController, bookingDetails: bookingDetails,),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              ResponsiveHelper.isDesktop(context) ? _DesktopView(bookingDetails: bookingDetails, tabController: tabController!,) :
              Column(children: [

                RepeatBookingInfoWidget(bookingDetailsContent: bookingDetails),

                const SizedBox(height: Dimensions.paddingSizeLarge),
                ScheduleWidget(bookingDetailsContent : bookingDetails),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                nextBooking !=null ?
                NextServiceWidget(booking: nextBooking) : const SizedBox(),

                const SizedBox(height: Dimensions.paddingSizeLarge),
                AllBookingSummaryWidget(tabController: tabController, bookingDetails: bookingDetails),

                const SizedBox(height: Dimensions.paddingSizeLarge),
                RepeatBookingSummeryWidget(bookingDetails: bookingDetails),

                const SizedBox(height: Dimensions.paddingSizeDefault),
                bookingDetails.provider != null ? ProviderInfo(provider: bookingDetails.provider!) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                bookingDetails.serviceman != null ? ServiceManInfo(user: bookingDetails.serviceman!.user!) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                bookingDetails.photoEvidenceFullPath != null && bookingDetails.photoEvidenceFullPath!.isNotEmpty ?
                BookingPhotoEvidence(bookingDetailsContent: bookingDetails): const SizedBox(),

                SizedBox(height: bookingStatus == "completed" && isLoggedIn ? Dimensions.paddingSizeExtraLarge * 3 : Dimensions.paddingSizeExtraLarge ),

              ])
            ]),
          ),
          ResponsiveHelper.isDesktop(context) ? const FooterView() :  const SizedBox(),
        ]),
        );
      }else{
        return const SingleChildScrollView(child: BookingScreenShimmer());
      }
    });
  }
}

class _DesktopView extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final TabController tabController;
  const _DesktopView({required  this.bookingDetails, required this.tabController});

  @override
  Widget build(BuildContext context) {

    RepeatBooking ? nextBooking = BookingHelper.getNextUpcomingRepeatBooking(bookingDetails);
    return Center(
      child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
          child: Row( crossAxisAlignment: CrossAxisAlignment.start, children: [

            Expanded(
              child: Column(children: [
                IntrinsicHeight(
                  child: Row(children: [
                    Expanded( child: ScheduleWidget(bookingDetailsContent : bookingDetails)),
                    SizedBox(width : nextBooking !=null ?  Dimensions.paddingSizeLarge : 0),
                    nextBooking !=null ?
                    Expanded(child: NextServiceWidget(booking: nextBooking )) : const SizedBox(),
                  ]),
                ),

                const SizedBox(height: Dimensions.paddingSizeLarge),
                AllBookingSummaryWidget(tabController: tabController, bookingDetails: bookingDetails),

                const SizedBox(height: Dimensions.paddingSizeLarge),
                RepeatBookingSummeryWidget(bookingDetails: bookingDetails),

                const SizedBox(height:  Dimensions.paddingSizeExtraLarge ),

              ]),
            ),
            const SizedBox(width:   Dimensions.paddingSizeLarge ),
            SizedBox(
              width: Dimensions.webMaxWidth / 3.5,
              child: Column(children: [
                 ProviderInfo(provider: bookingDetails.provider) ,
                const SizedBox(height: Dimensions.paddingSizeSmall),

                bookingDetails.serviceman != null ? ServiceManInfo(user: bookingDetails.serviceman!.user!) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeSmall),
              ]),
            )
          ]),
        ),
      ),
    );
  }
}

