import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:demandium/feature/review/repo/submit_review_repo.dart';

class SubmitReviewController extends GetxController {
  final SubmitReviewRepo submitReviewRepo ;
  SubmitReviewController({required this.submitReviewRepo});


  bool _isLoading = false;
  get isLoading => _isLoading;

  bool _loading = false;
  get loading => _loading;

  List<Service>? _serviceReviewList;
  List<Service>? get serviceReviewList => _serviceReviewList;

  Map<String,Map<String, dynamic>> listOfReview = {};

  TextEditingController reviewController = TextEditingController();
  Map<String, TextEditingController> textControllers =  {};
  Map<String, int> selectedRating =  {};
  Map<String, bool> isEditable =  {};
  Map<String, String> reviewComments =  {};

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

   selectReview(int rating,serviceId){
     selectedRating[serviceId] = rating;
    update();
  }

  void setIndex(int index){
    _selectedIndex= index;
    update();
  }

  Future<void> submitReview(ReviewBody reviewBody,String serviceId,String review, int index)async{
    _isLoading = true;
    update();
    Response response =await submitReviewRepo.submitReview(reviewBody: reviewBody);
    if(response.statusCode == 200){
      isEditable[serviceId] = false;
      reviewComments[serviceId]= review;
      customSnackBar('review_submitted_successfully'.tr,type : ToasterMessageType.success);
    }
    _isLoading = false;
    update();
  }


  Future<void> getReviewList(String bookingId)async{

    Response response =await submitReviewRepo.getReviewList(bookingId: bookingId);
    if(response.statusCode == 200){

      if( response.body['content'] !=null && response.body['content'].isNotEmpty){
        List<dynamic> list = response.body['content'];
        _serviceReviewList = [];
        for (var element in list) {
          _serviceReviewList!.add(Service.fromJson(element));
        }
        _serviceReviewList?.forEach((element){

          textControllers[element.id!] = TextEditingController();

          if(element.review != null && element.review!.isNotEmpty){
            selectedRating[element.id!] = element.review!.first.reviewRating ?? 5;
            isEditable[element.id!] = element.review!.isEmpty;
            reviewComments[element.id!] = element.review!.first.reviewComment ?? "";
            textControllers[element.id]!.text = element.review!.first.reviewComment ?? "";
          }else{
            selectedRating[element.id!] = 5;
            isEditable[element.id!] = true;
            reviewComments[element.id!] =  "";
            textControllers[element.id]!.text = "";
          }
        });
      }
    }
    _loading = false;
    update();
  }

  void updateEditableValue(String serviceId,bool value,{bool isUpdate= false}){
    isEditable[serviceId] = value;
    if(isUpdate){
      update();
    }
  }
}