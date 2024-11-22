import 'package:get/get.dart';
import 'package:demandium/utils/core_export.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key}) ;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(
        title: 'edit_profile'.tr,
        centerTitle: true,
        bgColor: Theme.of(context).primaryColor,
        isBackButtonExist: true,
      ),
      body: FooterBaseView(
        isScrollView: ResponsiveHelper.isMobile(context) ? false : true,
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: WebShadowWrap(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  if(!ResponsiveHelper.isMobile(context))
                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: DecoratedTabBar(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.primary.withOpacity(.3),
                            width: 1.0,
                          ),
                        ),
                      ),
                      tabBar: TabBar(
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        labelColor: Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor,
                        labelStyle: ubuntuMedium,

                        tabs: [
                          Tab(text: 'general_info'.tr),
                          Tab(text: 'account_information'.tr),
                        ],
                        onTap: (int index) {
                          switch (index) {
                            case 0:
                              Get.find<UserController>().updateEditProfilePage(EditProfileTabControllerState.generalInfo,index);
                              break;
                            case 1:
                              Get.find<UserController>().updateEditProfilePage(EditProfileTabControllerState.accountIno,index);
                              break;
                          }
                        },

                      ),
                    ),
                  ),
                  (!ResponsiveHelper.isMobile(context)) ? SizedBox(height: Get.height * 0.7,
                    child: GetBuilder<UserController>(builder: (userController){
                      return  userController.editProfilePageCurrentState == EditProfileTabControllerState.generalInfo?
                      EditProfileGeneralInfo(tooltipController: tooltipController,):const EditProfileAccountInfo();
                    })) : Expanded(
                      child: TabBarView(children: [
                        EditProfileGeneralInfo(tooltipController: tooltipController,),
                        const EditProfileAccountInfo(),
                  ]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
