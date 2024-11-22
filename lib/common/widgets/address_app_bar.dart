import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class AddressAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? backButton;
  const AddressAppBar({super.key, this.backButton = true});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:Get.isDarkMode ? Theme.of(context).cardColor.withOpacity(.2):Theme.of(context).primaryColor,
      shape: Border(bottom: BorderSide(width: .4, color: Theme.of(context).primaryColorLight.withOpacity(.2))),
      elevation: 0, leadingWidth: backButton! ? Dimensions.paddingSizeLarge : 0,
      leading: backButton! ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Theme.of(context).cardColor,
        onPressed: () => Navigator.pop(context),
      ):
      const SizedBox(),
      title: Row( children: [
        Expanded(
          child: InkWell(
            hoverColor: Colors.transparent,
            onTap: () => Get.toNamed(RouteHelper.getAccessLocationRoute('address')),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('services_in'.tr, style: ubuntuRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)),
              const SizedBox(height: Dimensions.paddingSizeTine),
              GetBuilder<LocationController>(builder: (locationController) {
                return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
                  if(locationController.getUserAddress() != null) Flexible(
                    child: Text(
                      locationController.getUserAddress()!.address!,
                      style: ubuntuMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall), maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 12),
                  const SizedBox(width: Dimensions.paddingSizeLarge,)
                ]);
              }),
            ]),
          ),
        ),
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          child: const Icon(Icons.notifications, size: 25, color: Colors.white),
        ),
      ]),
    );
  }
  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 70 :  56);
}