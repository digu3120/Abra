import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';


class NearbyProviderController extends GetxController implements GetxService {
  final ProviderBookingRepo providerBookingRepo;
  NearbyProviderController({required this.providerBookingRepo});


  final bool _isLoading = false;
  get isLoading => _isLoading;

  ProviderModel? _providerModel;
  ProviderModel? get providerModel => _providerModel;


  List<CategoryModelItem> categoryItemList = [];

  List<ProviderData>? _providerList;
  List<ProviderData>? get  providerList=> _providerList;

  final List<PredictionModel> _predictionList = [];
  PredictionModel? _firstPredictionModel;

  List<PredictionModel> get predictionList => _predictionList;
  PredictionModel? get firstPredictionModel => _firstPredictionModel;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  final List<String> _sortBy = ['default','asc',"desc", 'popular'];
  List<String>  get sortBy => _sortBy;

  List<bool> _categoryCheckList =[];
  List<bool> get categoryCheckList => _categoryCheckList;

  String _selectedSortBy = "default";
  String get selectedSortBy => _selectedSortBy;

  final List<String> _ratingFilter = ['5','4', '3', '2','1'];
  List<String>  get ratingFilter => _ratingFilter;

  List<String> _selectedCategoryId =[];
  List<String> get selectedCategoryId => _selectedCategoryId;

  String? _selectedRating;
  String? get selectedRating => _selectedRating;

  int? _providerAvailableStatus;
  int? get providerAvailableStatus => _providerAvailableStatus;

  Set<Marker> markers = HashSet<Marker>();

  int selectedProviderIndex = -1;
  AutoScrollController? scrollController;


  bool isPopupMenuOpened = false;

  Future<void> getProviderList(int offset, bool reload, {bool applyFilter = false, LatLng? initialPosition}) async {

    if(offset != 1 || _providerModel == null || reload){
      if(reload){
        _providerModel = null;
      }

      if(!applyFilter){
        clearFilterDataValues(shouldUpdate: false);
      }

      Map<String,dynamic> body={
        'sort_by': _selectedSortBy ,
         "rating" : _selectedRating ?? "0",
      };

      if(selectedCategoryId.isNotEmpty){
        body.addAll({'category_ids': selectedCategoryId});
      }

      if(_providerAvailableStatus !=null){
        body.addAll({'service_availability': _providerAvailableStatus});
      }

      Response response = await providerBookingRepo.getProviderList(offset,body, limit: 100);
      if (response.statusCode == 200) {
        if(reload){
          _providerList = [];
        }
        _providerModel = ProviderModel.fromJson(response.body);
        if(_providerModel != null && offset != 1){
          _providerList!.addAll(ProviderModel.fromJson(response.body).content?.data??[]);
        }else{
          _providerList = [];
          _providerList!.addAll(ProviderModel.fromJson(response.body).content?.data??[]);
        }

        _providerList?.forEach((element) {
          double distance = MapHelper.getDistanceBetweenUserCurrentLocationAndProvider(Get.find<LocationController>().getUserAddress()!, element);
          element.distance = distance;
        });

        if(_selectedSortBy == "default"){
          _providerList!.sort((a, b) => a.distance!.compareTo(b.distance!));
        }
        selectedProviderIndex = -1;

        if(initialPosition !=null && _mapController !=null){
          setMarker(_mapController!, initialPosition);
        }

      } else {
         ApiChecker.checkApi(response);
      }

      update();
    }
  }


  int _apiHitCount = 0;

  Future<void> updateIsFavoriteStatus({ required String providerId, required int index}) async {



    _apiHitCount ++;
    updateIsFavoriteValue(_providerList?[index].isFavorite == 1 ? 0 : 1,providerId);
    update();
    Response response = await providerBookingRepo.updateIsFavoriteStatus(serviceId: providerId);

    _apiHitCount --;
    int status;
    if(response.statusCode == 200 && (response.body['response_code'] == "provider_favorite_store_200" || response.body['response_code'] == "provider_remove_favorite_200")){
      if(response.body['content']['status'] !=null){
        status  = response.body['content']['status'];
        updateIsFavoriteValue(status,providerId);
        customSnackBar(response.body['message'], type : status == 1 ? ToasterMessageType.success : ToasterMessageType.error);
      }
    }

    if(_apiHitCount ==0){
      update();
    }
  }

  updateIsFavoriteValue(int status, String providerId, {bool shouldUpdate = false, bool fromExploreProviderScreen = true}){

    int? index = _providerList?.indexWhere((element) => element.id == providerId);
    if(index !=null && index > -1){
      _providerList?[index].isFavorite = status;
    }

    if(fromExploreProviderScreen){
      Get.find<ProviderBookingController>().updateProviderIsFavoriteValue(status, providerId, shouldUpdate: true, fromProviderBooking: false);
    }
    if(shouldUpdate){
      update();
    }
  }

  Future<void> getCurrentLocation({GoogleMapController? mapController, LatLng? defaultLatLng, bool notify = true}) async {

    final BitmapDescriptor currentLocationIcon = await  convertAssetToUnit8List(Images.currentLocation, width:  50, height: 50);

    Position myPosition;
    try {
      Geolocator.requestPermission();
      Position newLocalData = await Geolocator.getCurrentPosition();
      myPosition = newLocalData;

    }catch(e) {
      if(defaultLatLng != null){
        myPosition = Position(
            latitude:defaultLatLng.latitude,
            longitude:defaultLatLng.longitude,
            timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,  altitudeAccuracy: 1, headingAccuracy: 1
        );
      }else{
        myPosition = Position(
            latitude:  Get.find<SplashController>().configModel.content?.defaultLocation?.latitude ?? 23.0000,
            longitude: Get.find<SplashController>().configModel.content?.defaultLocation?.longitude ?? 90.0000,
            timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,  altitudeAccuracy: 1, headingAccuracy: 1
        );
      }
    }

    if (mapController != null) {

      if(kIsWeb){
        markers.add(Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(myPosition.latitude, myPosition.longitude),
          infoWindow: InfoWindow(title: "my_location".tr,
            snippet: Get.find<LocationController>().getUserAddress()?.address ??"",
          ),
          icon:  currentLocationIcon,
        ));
      }

      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 16),
      ));
    }

    update();

  }




  Future<void> setMarker(GoogleMapController mapController, LatLng initialPosition) async {

    final BitmapDescriptor selectedProvider = await convertAssetToUnit8List(Images.selectedProvider,width:  70, height:70);
    final BitmapDescriptor unselectedProvider = await  convertAssetToUnit8List(Images.selectedProvider, width:  60, height: 60);
    final BitmapDescriptor currentLocationIcon = await  convertAssetToUnit8List(
      Images.marker, width: kIsWeb ? 40 : 25, height: kIsWeb ? 60 :  40,
    );

    // Marker
    markers = HashSet<Marker>();
    for(int index = 0; index < _providerList!.length; index++) {

      if(_providerList![index].coordinates !=null){
        markers.add(Marker(
          onTap: () async {
            _resetMarker(index, mapController, initialPosition, selectedProvider, unselectedProvider, currentLocationIcon);
            await scrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
            await scrollController!.highlight(index);
          },
          markerId: MarkerId('$index'),
          position: LatLng(_providerList![index].coordinates!.latitude!, _providerList![index].coordinates!.longitude!),
          infoWindow: InfoWindow(title: _providerList![index].companyName),
          icon: GetPlatform.isIOS ? BitmapDescriptor.defaultMarker :  selectedProviderIndex == index ?  selectedProvider : unselectedProvider,
          alpha:  1
        ));
      }
    }

    markers.add(Marker(
      markerId: const MarkerId('saved_address'),
      position: initialPosition,
      infoWindow: InfoWindow(title: "my_location".tr,
        snippet: Get.find<LocationController>().getUserAddress()?.address ??"",
      ),
      icon: GetPlatform.isIOS ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen): currentLocationIcon,
    ));

    mapBound(mapController, initialPosition);

  }

  void _resetMarker(int index, GoogleMapController mapController, LatLng initialPosition, BitmapDescriptor selectedProvider,BitmapDescriptor unselectedProvider, BitmapDescriptor currentLocationIcon){
    selectedProviderIndex = index;

    markers = HashSet<Marker>();
    for(int index = 0; index < _providerList!.length; index++) {

      if(_providerList![index].coordinates !=null){
        markers.add(Marker(
          onTap: () async {
            _resetMarker(index, mapController, initialPosition, selectedProvider, unselectedProvider, currentLocationIcon);
            await scrollController!.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
            await scrollController!.highlight(index);
          },
          markerId: MarkerId('$index'),
          position: LatLng(_providerList![index].coordinates!.latitude!, _providerList![index].coordinates!.longitude!),
          infoWindow: InfoWindow(title: _providerList![index].companyName),
          icon: GetPlatform.isIOS ? BitmapDescriptor.defaultMarker : selectedProviderIndex == index ?  selectedProvider : unselectedProvider,
            alpha: 1
        ));
      }
    }

    markers.add(Marker(
      markerId: const MarkerId('saved_address'),
      position: initialPosition,
      infoWindow: InfoWindow(title: "my_location".tr,
        snippet: Get.find<LocationController>().getUserAddress()?.address ??"",
      ),
      icon: GetPlatform.isIOS ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen): currentLocationIcon,
    ));

    update();
  }



  Future<BitmapDescriptor> convertAssetToUnit8List(String imagePath, {double height = 50 ,double width = 50}) async {
    return BitmapDescriptor.asset(ImageConfiguration(size: Size(width, height)), imagePath);
  }


  void mapBound(GoogleMapController controller,  LatLng initialPosition) async {
    List<LatLng> latLongList = [];
    latLongList.add(initialPosition);
    for (int index = 0; index < _providerList!.length; index++) {
      if(_providerList![index].coordinates !=null){
        latLongList.add(LatLng(_providerList![index].coordinates!.latitude!, _providerList![index].coordinates!.longitude!));
      }
    }
    await controller.getVisibleRegion();
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.animateCamera(CameraUpdate.newLatLngBounds(
        MapHelper.boundsFromLatLngList(latLongList),
        100.5,
      ));
    });

    update();
  }

  void updateSortBy(String value){
    _selectedSortBy = value;
    update();
  }

  void updateFilterByRating(String value){
    _selectedRating= value;
    update();
  }

  void toggleFromCampaignChecked(int index) {

    List<CategoryModel> categoryList = Get.find<CategoryController>().categoryList ?? [];
    _categoryCheckList[index] = !categoryCheckList[index];

    if(_categoryCheckList[index]==true){
      if(!_selectedCategoryId.contains(categoryList[index].id)){
        _selectedCategoryId.add(categoryList[index].id!);
      }
    }else{
      if(_selectedCategoryId.contains(categoryList[index].id)){
        _selectedCategoryId.remove(categoryList[index].id);
      }
    }
    update();

  }

  void resetCategoryCheckedList({bool shouldUpdate = true}){
    Get.find<CategoryController>().categoryList?.forEach((element) {
      _categoryCheckList.add(false);
    });

    if(shouldUpdate){
      update();
    }
  }

  clearFilterDataValues ({bool shouldUpdate = true}){
    _selectedCategoryId=[];
    _categoryCheckList = [];
    _selectedRating = null;
    _selectedSortBy = "default";
    _providerAvailableStatus = null;
    resetCategoryCheckedList(shouldUpdate: false);
    if(shouldUpdate){
      update();
    }

  }
  bool isFilteredApplied() {
    if(_selectedRating == null && _selectedCategoryId.isEmpty && _selectedSortBy == "default" && _providerAvailableStatus == null){
      return false;
    }
    return true;
  }

  updateProviderAvailableStatus({int? value, bool shouldUpdate = true}){
    _providerAvailableStatus = _providerAvailableStatus == 1 ? 0 : 1;

    if(shouldUpdate){
      update();
    }
  }

  updatePopMenuStatus(bool newValue, {bool shouldUpdate = true}){
    isPopupMenuOpened = newValue;

    if(shouldUpdate){
      update();
    }

  }

  setMapController({GoogleMapController? controller}){
    _mapController = controller;
  }

}