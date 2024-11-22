import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';
import 'package:lottie/lottie.dart';

class PickMapScreen extends StatefulWidget {
  final bool? fromSignUp;
  final bool? fromAddAddress;
  final bool? canRoute;
  final String? route;
  final bool formCheckout;
  final GoogleMapController? googleMapController;
  final ZoneModel? zone;
  final AddressModel? previousAddress;
  const PickMapScreen({super.key,
    required this.fromSignUp, @required this.fromAddAddress, @required this.canRoute,
    required this.route, this.googleMapController,
    required this.formCheckout, required this.zone,
    this.previousAddress
  });

  @override
  State<PickMapScreen> createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  LatLng? _initialPosition;
  LatLng? _centerLatLng;

  Set<Polygon> _polygone = {};
  List<LatLng> zoneLatLongList = [];

  @override
  void initState() {
    super.initState();
    if(widget.fromAddAddress!) {
      Get.find<LocationController>().setPickData();

    }

    if(widget.zone !=null){
      _centerLatLng = Get.find<ServiceAreaController>().computeCentroid(coordinates: widget.zone!.formattedCoordinates!);
      _initialPosition = LatLng(_centerLatLng!.latitude , _centerLatLng!.longitude);

      widget.zone?.formattedCoordinates?.forEach((element) {
        zoneLatLongList.add(LatLng(element.latitude!, element.longitude!));
      });

      List<Polygon> polygonList = [];

      polygonList.add(
        Polygon(
          polygonId: const PolygonId('1'),
          points: zoneLatLongList,
          strokeWidth: 2,
          strokeColor: Get.theme.colorScheme.primary,
          fillColor: Get.theme.colorScheme.primary.withOpacity(.2),
        ),
      );

      _polygone = HashSet<Polygon>.of(polygonList);

    }else{
      _initialPosition = LatLng(
        Get.find<SplashController>().configModel.content?.defaultLocation?.latitude ?? 23.00000,
        Get.find<SplashController>().configModel.content?.defaultLocation?.longitude ?? 90.00000,
      );
    }

  }

  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: () {
        if (_canExit) {
          if(!GetPlatform.isWeb) {
            exit(0);
          }
        } else {
          customSnackBar('back_press_again_to_exit'.tr, type : ToasterMessageType.info);
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
        }
      },
      child: Scaffold(
        endDrawer: ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        body: SafeArea(child: Center(
          child: WebShadowWrap(
            child: GetBuilder<LocationController>(builder: (locationController) {
              return Stack(children: [

                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.fromAddAddress! ?   LatLng(locationController.position.latitude, locationController.position.longitude) : _initialPosition!,
                    zoom: 16
                  ),
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  onMapCreated: (GoogleMapController mapController) {
                    _mapController = mapController;
                    if(!widget.fromAddAddress!) {

                      if(widget.zone != null){
                        Future.delayed( const Duration(milliseconds: 500),(){
                          mapController.animateCamera(CameraUpdate.newLatLngBounds(
                            MapHelper.boundsFromLatLngList(zoneLatLongList),
                            100.5,
                          ));
                        });

                      }else {
                        Get.find<LocationController>().getCurrentLocation(false, mapController: mapController );
                      }
                    }
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    _cameraPosition = cameraPosition;
                  },
                  onCameraMoveStarted: () {
                    locationController.updateCameraMovingStatus(true);
                    locationController.disableButton();
                  },
                  onCameraIdle: () {
                    locationController.updateCameraMovingStatus(false);
                    try{
                      Get.find<LocationController>().updatePosition(_cameraPosition!, false, formCheckout: widget.formCheckout);
                    }catch(e){
                        if (kDebugMode) {
                          print('');
                        }
                    }
                  },
                  style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  polygons: _polygone,
                ),

                Center(child: Padding(
                  padding:  const EdgeInsets.only(bottom: Dimensions.pickMapIconSize * 0.65),
                  child: locationController.isCameraMoving ? const AnimatedMapIconExtended() : const AnimatedMapIconMinimised(),
                )),

                Positioned(
                  top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                  child: InkWell(
                    onTap: () => Get.dialog(LocationSearchDialog(mapController: _mapController!)),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                      child: Row(children: [
                        Icon(Icons.location_on, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6)),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Expanded(
                          child: Text(
                            locationController.pickAddress.address ?? "",
                            style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                      ]),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 80, right: Dimensions.paddingSizeSmall,
                  child: FloatingActionButton(
                    hoverColor: Colors.transparent,
                    mini: true, backgroundColor:Theme.of(context).colorScheme.primary,
                    onPressed: () => _checkPermission(() {
                      Get.find<LocationController>().getCurrentLocation(false, mapController: _mapController);
                    }),
                    child: Icon(Icons.my_location,
                        color: Colors.white.withOpacity(0.9)
                    ),
                  ),
                ),

                Positioned(
                  bottom: 30.0, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                  child: CustomButton(
                    fontSize: Dimensions.fontSizeDefault,
                    buttonText: locationController.inZone ? widget.fromAddAddress! ? 'pick_address'.tr : 'pick_location'.tr
                        : 'service_not_available_in_this_area'.tr,
                    onPressed: (locationController.buttonDisabled || locationController.loading) ? null : () {
                      if(locationController.pickPosition.latitude != 0 && locationController.pickAddress.address!.isNotEmpty) {
                        if(widget.fromAddAddress!) {
                          if(widget.googleMapController != null) {
                            widget.googleMapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                              locationController.pickPosition.latitude, locationController.pickPosition.longitude,
                            ), zoom: 16)));
                            locationController.setAddAddressData();
                          }
                          Get.back();
                        }else {

                          String? firstName;

                          if(Get.find<AuthController>().isLoggedIn() && Get.find<UserController>().userInfoModel?.phone!=null && Get.find<UserController>().userInfoModel?.fName !=null){
                            firstName = "${Get.find<UserController>().userInfoModel?.fName} ";
                          }

                          AddressModel address = AddressModel(
                            latitude: locationController.pickPosition.latitude.toString(),
                            longitude: locationController.pickPosition.longitude.toString(),
                            addressType: 'others',
                            address: locationController.pickAddress.address ?? "",
                            city: locationController.pickAddress.city ?? "",
                            country : locationController.pickAddress.country ?? "",
                            house : locationController.pickAddress.house ?? "",
                            street : locationController.pickAddress.street ?? "",
                            zipCode: locationController.pickAddress.zipCode ??"",
                            addressLabel: AddressLabel.home.name,
                            contactPersonNumber: firstName !=null? Get.find<UserController>().userInfoModel?.phone ?? "" : "",
                            contactPersonName: firstName!=null ? "$firstName${Get.find<UserController>().userInfoModel?.lName ?? "" }" : ""
                          );

                         locationController.saveAddressAndNavigate(address, widget.fromSignUp!, widget.route ?? RouteHelper.getMainRoute('home'), widget.canRoute!, true );
                        }
                      }else {
                        customSnackBar('pick_an_address'.tr, type: ToasterMessageType.info);
                      }
                    },
                  ),
                ),
              ]);
            }),
          ),
        )),
      ),
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      customSnackBar('you_have_to_allow'.tr, type: ToasterMessageType.info);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialog());
    }else {
      onTap();
    }
  }
}


class AnimatedMapIconExtended extends StatefulWidget {
  const AnimatedMapIconExtended({super.key});

  @override
  State<AnimatedMapIconExtended> createState() => _AnimatedMapIconExtendedState();
}

class _AnimatedMapIconExtendedState extends State<AnimatedMapIconExtended>  {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController){
      return Center(
        child: Stack( alignment: AlignmentDirectional.center, children: [
          Lottie.asset(Images.mapIconExtended , repeat: false, height: Dimensions.pickMapIconSize,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(
                  const ['Red circle Outlines', '**'],
                  value: Theme.of(context).colorScheme.primary,
                ),
                ValueDelegate.color(
                  const ['Shape Layer 1', '**'],
                  value: Theme.of(context).colorScheme.primary,
                ),
                ValueDelegate.color(
                  const ['Layer 4', 'Group 1', 'Stroke 1', '**'],
                  value: Theme.of(context).colorScheme.primary,
                ),
                // Change color of Stroke 1 in Group 2
                ValueDelegate.color(
                  const ['Layer 4', 'Group 2', 'Stroke 1', '**'],
                  value: Theme.of(context).colorScheme.primary,
                ),
                // Change color of Stroke 1 in Group 3
                ValueDelegate.color(
                  const ['Layer 4', 'Group 3', 'Stroke 1', '**'],
                  value: Theme.of(context).colorScheme.primary,
                ),
                ValueDelegate.color(
                  const ['shadow Outlines', '**'],
                  value: Theme.of(context).colorScheme.primary,
                )
              ],
            ),

          ),
           Padding(
             padding:  const EdgeInsets.only(top: Dimensions.pickMapIconSize * 0.4),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min,
               children: List.generate(9, (index){
                 return  Icon(Icons.circle, size: index == 8 ? Dimensions.pickMapIconSize * 0.06 : Dimensions.pickMapIconSize * 0.03,
                   color: Theme.of(context).colorScheme.primary,
                 );
               }),
             ),
           ),
        ],),
      );
    });
  }
}


class AnimatedMapIconMinimised extends StatefulWidget {
  const AnimatedMapIconMinimised({super.key});

  @override
  State<AnimatedMapIconMinimised> createState() => _AnimatedMapIconMinimisedState();
}

class _AnimatedMapIconMinimisedState extends State<AnimatedMapIconMinimised> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController){
      return Center(
        child: Stack( alignment: AlignmentDirectional.center, children: [
          Lottie.asset(Images.mapIconMinimised , repeat: false, height: Dimensions.pickMapIconSize,
            delegates: LottieDelegates(
              values: [
                ValueDelegate.color(
                  const ['Red circle Outlines', '**'],
                  value: Theme.of(context).colorScheme.primary,
                ),
                ValueDelegate.color(
                  const ['Shape Layer 1', '**'],
                  value: Theme.of(context).colorScheme.primary,
                ),
                ValueDelegate.color(
                  const ['shadow Outlines', '**'],
                  value: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
          ),

          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 0.1),
            duration: const Duration(milliseconds: 400),
            builder: (BuildContext context, double value, Widget? child) {
              return Padding(
                padding:  const EdgeInsets.only(top: Dimensions.pickMapIconSize * 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min,
                  children: List.generate(9, (index){
                    return  Icon(Icons.circle, size: index == 8 ? Dimensions.pickMapIconSize * 0.06 : Dimensions.pickMapIconSize * 0.03,
                      color: Theme.of(context).colorScheme.primary.withOpacity(value),
                    );
                  }),
                ),
              );
            },
          )
        ],),
      );
    });
  }
}

