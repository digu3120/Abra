import 'package:demandium/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;


class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    String currentUrl = _saveErrorUrlIntoServer();

    Future.delayed( const Duration(milliseconds: 500),() {
      setState(() {
        isLoading = false;
      });
      if(_hasRedirectionUrl(currentUrl) != ""){
        String url = _hasRedirectionUrl(currentUrl);
        if(_checkExternalRedirection(url)){
          _launchURL(url);
        }else{
          html.window.location.href = url;
        }
      }
    });
  }

  String _saveErrorUrlIntoServer(){
    String hostname = html.window.location.hostname!;
    String protocol = html.window.location.protocol;
    String port = html.window.location.port;
    String hostedUrl = "$protocol//$hostname:$port";
    String currentURL = hostedUrl + Get.currentRoute;
    Get.find<SplashController>().addError404UrlToServer(currentURL);
    return currentURL;
  }

  String _hasRedirectionUrl(String currentUrl){
    var config = Get.find<SplashController>().configModel.content;
    String redirectUrl = "";
    if( config !=null && config.errorLogs !=null && config.errorLogs!.isNotEmpty){
      config.errorLogs!.any((element){
        redirectUrl = element.url == currentUrl ? element.redirectUrl! : "";
        return element.url == currentUrl;
      });
    }
    if (kDebugMode) {
      print("Redirect Url : $redirectUrl");
    }
    return redirectUrl;
  }

  bool _checkExternalRedirection(String url){
    String hostname = html.window.location.hostname!;
    String protocol = html.window.location.protocol;
    String port = html.window.location.port;
    String hostedUrl = "$protocol//$hostname:$port";
    if(url.contains(hostedUrl)){
      return false;
    }else{
      return true;
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "page_not_found".tr),
      endDrawer: ResponsiveHelper.isDesktop(context) ? const MenuDrawer() : null,
      body: FooterBaseView(
        isCenter: true,
        child: WebShadowWrap(
          child: isLoading ? const Center(child: CustomLoader()) : Center(child: Column(children: [
            Image.asset(Images.error404, width: 200),
            const SizedBox(height: Dimensions.paddingSizeLarge,),
            Text('oops_page_not_found'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Text("the_page_you_entered".tr,
              style:  ubuntuRegular.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Get.height * 0.1,),
            CustomButton(buttonText: "back_to_home".tr, width: 250, onPressed: (){
              Get.offAllNamed(RouteHelper.getMainRoute('home'));
            })
          ]),
          ) ,
        ),
      ),
    );
  }
}
