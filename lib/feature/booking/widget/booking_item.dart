import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class BookingItem extends StatelessWidget {
  const BookingItem(
      {super.key, required this.img, required this.title, required this.date});
  final String img;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Image.asset(
        img,
        height: 15,
        width: 15,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      ),
      const SizedBox(width: Dimensions.paddingSizeSmall),
      Expanded(
        child: Row(children: [
          Flexible(
            child: Text(
              title.tr,
              style: ubuntuLight.copyWith(
                fontSize: Dimensions.fontSizeSmall,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            date,
            style: ubuntuLight.copyWith(
              fontSize: Dimensions.fontSizeSmall,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.ltr,
          ),
        ]),
      ),
    ]);
  }
}
