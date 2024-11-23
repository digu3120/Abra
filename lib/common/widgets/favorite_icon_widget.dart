import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';

class FavoriteIconWidget extends StatefulWidget {
  final int? value;
  final String? serviceId;
  final String? providerId;
  final bool? showDialog;
  final int? index;
  final GlobalKey<CustomShakingWidgetState>? signInShakeKey;
  const FavoriteIconWidget(
      {super.key,
      this.value,
      this.serviceId,
      this.providerId,
      this.signInShakeKey,
      this.showDialog,
      this.index});

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _controller.reverse().then((value) => _controller.forward());

        if (Get.find<AuthController>().isLoggedIn()) {
          if (widget.showDialog == true) {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (context) => FavoriteItemRemoveDialog(
                providerId: widget.providerId,
                serviceId: widget.serviceId,
              ),
              backgroundColor: Colors.transparent,
            );
          } else {
            if (widget.providerId != null) {
              Get.find<ProviderBookingController>().updateIsFavoriteStatus(
                  providerId: widget.providerId!, index: widget.index);
            } else if (widget.serviceId != null) {
              Get.find<ServiceController>().updateIsFavoriteStatus(
                serviceId: widget.serviceId!,
                currentStatus: widget.value ?? 0,
              );
            }
          }
        } else {
          widget.signInShakeKey?.currentState?.shake();
          customSnackBar(
            "message",
            customWidget: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(children: [
                    const Icon(Icons.info, color: Colors.blueAccent, size: 20),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Flexible(
                      child: Text(
                        "please_login_to_add_favorite_list".tr,
                        style: ubuntuRegular.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                  ]),
                ),
                InkWell(
                  onTap: () => Get.toNamed(RouteHelper.getSignInRoute()),
                  child: Text('sign_in'.tr,
                      style: ubuntuRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      )),
                ),
              ],
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: ScaleTransition(
          scale: Tween(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
          child: Image.asset(
            widget.value == 1 ? Images.favorite : Images.unFavorite,
            width: 23,
          ),
        ),
      ),
    );
  }
}
