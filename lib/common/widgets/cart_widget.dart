import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class CartWidget extends GetView<CartController> {
  final Color color;
  final double size;
  final bool fromRestaurant;
  const CartWidget({super.key, required this.color, required this.size, this.fromRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [

      Image.asset(Images.cart, width: size, height: size, color: color),
      GetBuilder<CartController>(builder: (cartController) {
        return cartController.cartList.isNotEmpty ? Positioned(
          top: -5, right: 0,
          child: Container(
            height:  size/1.7, width: size/1.7, alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.red,
            ),
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  cartController.cartList.length.toString(),
                  style: ubuntuMedium.copyWith(
                    fontSize: size/3 ,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ):
        const SizedBox();
      }),

    ]);
  }
}
