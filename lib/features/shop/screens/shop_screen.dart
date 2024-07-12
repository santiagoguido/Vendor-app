import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_vendor_app/features/shop/controllers/shop_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/confirmation_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_button_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_dialog_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_loader_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/shop_banner_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/shop_information_widget.dart';
import 'package:sixvalley_vendor_app/features/shop/widgets/vacation_dialog_widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  ShopScreenState createState() => ShopScreenState();
}

class ShopScreenState extends State<ShopScreen> {
  String sellerId = '0';
  TextEditingController vacationNote = TextEditingController();
  bool freeDeliveryOver = false;
  TextEditingController minimumOrderAmountController = TextEditingController();
  TextEditingController freeDeliveryOverAmountController = TextEditingController();
  bool freeDeliveryOn = false;


  @override
  void initState() {

    freeDeliveryOn = Provider.of<ProfileController>(context, listen: false).userInfoModel!.freeOverDeliveryAmountStatus == 1;
    minimumOrderAmountController.text = Provider.of<ProfileController>(context, listen: false).userInfoModel!.minimumOrderAmount.toString();
    freeDeliveryOverAmountController.text = Provider.of<ProfileController>(context, listen: false).userInfoModel!.freeOverDeliveryAmount.toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Provider.of<ShopController>(context, listen: false).selectedIndex;
    sellerId = Provider.of<ProfileController>(context, listen: false).userInfoModel!.id.toString();
    Provider.of<ShopController>(context, listen: false).getShopInfo();
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: CustomAppBarWidget(title : getTranslated('my_shop', context)),
        body: RefreshIndicator(
          onRefresh: () async{
            Provider.of<SplashController>(context, listen: false).initConfig();
          },
          child: Consumer<ShopController>(
              builder: (context, shopInfo, child) {

                return shopInfo.shopModel != null?
                Consumer<ProfileController>(
                  builder: (context, profileProvider,_) {
                    return SingleChildScrollView(
                      child: Consumer<SplashController>(
                        builder: (context, splashProvider,_) {
                          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              ShopBannerWidget(resProvider: shopInfo),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                child: ShopInformationWidget(resProvider: shopInfo)),

                              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Container(decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                  boxShadow: ThemeShadow.getShadow(context),
                                  color: Theme.of(context).cardColor),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    if(splashProvider.configModel?.minimumOrderAmountStatus == 1 && splashProvider.configModel?.minimumOrderAmountStatusBySeller ==1)
                                  Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeLarge,Dimensions.paddingSizeDefault,0),
                                    child: Text('${getTranslated('minimum_order_amount', context)} (${Provider.of<SplashController>(context, listen: false).myCurrency!.symbol})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),),

                                    if(splashProvider.configModel?.minimumOrderAmountStatus == 1 && splashProvider.configModel?.minimumOrderAmountStatusBySeller ==1)
                                  Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall,left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                                    child: CustomTextFieldWidget(border: true,
                                        controller: minimumOrderAmountController,
                                        isAmount: true,
                                        hintText: '${getTranslated('enter_minimum_order_amount', context)}')),

                                    if(splashProvider.configModel?.freeDeliveryStatus == 1 && splashProvider.configModel?.freeDeliveryResponsibility == 'seller')
                                      Consumer<ProfileController>(
                                      builder: (context, profileProvider,_) {
                                        return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeLarge,Dimensions.paddingSizeDefault,0),
                                          child: Row(children: [
                                            Expanded(child: Text('${getTranslated('free_delivery_over_amount', context)} (${Provider.of<SplashController>(context, listen: false).myCurrency!.symbol})', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge))),

                                            FlutterSwitch(width: 50,
                                                height: 27,
                                                toggleSize: 20,
                                                activeColor: Theme.of(context).primaryColor,
                                                padding: 2,
                                                value: freeDeliveryOn, onToggle: (val){
                                              setState(() {
                                                freeDeliveryOn = val;
                                              });
                                            })
                                          ],
                                          ),);
                                      }
                                  ),
                                    if(splashProvider.configModel?.freeDeliveryStatus == 1 && splashProvider.configModel?.freeDeliveryResponsibility == 'seller')
                                  Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall,left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                                    child: CustomTextFieldWidget(border: true,
                                        controller: freeDeliveryOverAmountController,
                                        isAmount: true,
                                        hintText: '${getTranslated('enter_free_delivery_over_amount', context)}'),),


                                    if((splashProvider.configModel?.minimumOrderAmountStatus == 1 && splashProvider.configModel?.minimumOrderAmountStatusBySeller ==1) || (splashProvider.configModel?.freeDeliveryStatus == 1 && splashProvider.configModel?.freeDeliveryResponsibility == 'seller'))
                                  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                        child: SizedBox(width: 70, child: CustomButtonWidget(btnTxt: '${getTranslated('save', context)}', onTap: (){
                                          if(freeDeliveryOverAmountController.text.trim().isEmpty && minimumOrderAmountController.text.trim().isEmpty){
                                            showCustomSnackBarWidget('${getTranslated('enter_minimum_order_amount_or_free_delivery_over_amount', context)}', context);
                                          }else{
                                           shopInfo.updateShopInfo(freeDeliveryOverAmount: freeDeliveryOverAmountController.text.trim(),
                                               freeDeliveryStatus: freeDeliveryOn? "1" : "0",
                                               minimumOrderAmount: minimumOrderAmountController.text.trim());
                                          }
                                        },)),
                                      ),
                                    ],
                                  ),
                                ],),),
                              ),


                             Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                               child: Container(decoration: BoxDecoration(
                                 color: Theme.of(context).cardColor,
                                   borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                 boxShadow: ThemeShadow.getShadow(context)
                               ),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                 shopInfo.shopModel != null?
                                 Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
                                   child: ShopSettingWidget(title: 'temporary_close', mode: shopInfo.shopModel?.temporaryClose != null ?
                                   shopInfo.shopModel!.temporaryClose : false,
                                     onTap: (value){
                                       showAnimatedDialogWidget(context, ConfirmationDialogWidget(
                                         icon: Images.logo,
                                         title: getTranslated('temporary_close_message', context),
                                         color: Theme.of(context).textTheme.bodyLarge!.color,
                                         onYesPressed: (){
                                           shopInfo.shopTemporaryClose(context, shopInfo.shopModel!.temporaryClose! ? 0 : 1);
                                         },
                                       ),
                                           isFlip: true
                                       );
                                     },),
                                 ): const SizedBox(),

                                 shopInfo.shopModel != null?
                                 Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
                                   child: ShopSettingWidget(title: 'vacation_mode', mode: shopInfo.shopModel!.vacationStatus! ,
                                     onTap: (value){
                                       showAnimatedDialogWidget(context, ConfirmationDialogWidget(
                                         icon: Images.logo,
                                         title: getTranslated('vacation_message', context),
                                         color: Theme.of(context).textTheme.bodyLarge!.color,
                                         onYesPressed: (){
                                           shopInfo.shopVacation(context,shopInfo.shopModel!.vacationStartDate, shopInfo.shopModel!.vacationEndDate, vacationNote.text, shopInfo.shopModel!.vacationStatus! ? 0 : 1);
                                         },
                                       ),
                                           isFlip: true
                                       );
                                     },),
                                 ): const SizedBox(),

                                 shopInfo.shopModel != null && shopInfo.shopModel!.vacationStatus! ?
                                 Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, 0, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall),
                                   child: ShopSettingWidget(title: 'vacation_date_range', mode: shopInfo.shopModel!.vacationStatus! ,
                                     dateSelection: true,
                                     onTap: (value){},
                                     onPress: (){
                                       showAnimatedDialogWidget(context, VacationDialogWidget(
                                         icon: Images.logo,
                                         title: getTranslated('vacation_message', context),
                                         vacationNote: vacationNote,
                                         onYesPressed: (){
                                           shopInfo.shopVacation(context, shopInfo.startDate, shopInfo.endDate,vacationNote.text, 1);
                                         },
                                       ),
                                           isFlip: true
                                       );
                                     },
                                   ),
                                 ):const SizedBox(),
                               ],),),
                             ),


                            if(splashProvider.configModel!.activeTheme == "theme_aster")
                              Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, top: Dimensions.paddingSizeDefault,
                                  right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault),
                              child: Row(children: [
                                Text('${getTranslated('store_secondary_banner', context)}',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              ],
                              ),
                            ),
                              if(shopInfo.shopModel != null && splashProvider.configModel!.activeTheme == "theme_aster")
                              Padding(padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeDefault, 0,  Dimensions.paddingSizeDefault,  Dimensions.paddingSizeDefault),
                                child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),child: ShopBannerWidget(resProvider: shopInfo, fromBottom: true))),


                            if(splashProvider.configModel!.activeTheme == "theme_fashion")
                            Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge,top: Dimensions.paddingSizeDefault,
                                right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeDefault),
                                child: Row(children: [
                                  Text('${getTranslated('offer_banner', context)}',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault))])),

                              if(shopInfo.shopModel != null && splashProvider.configModel!.activeTheme == "theme_fashion")
                                Padding(padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                                  child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                      child: ShopBannerWidget(resProvider: shopInfo, fromOffer: true,))),

                            ],
                          );
                        }
                      ),
                    );
                  }
                ):const CustomLoaderWidget();
              }),
        ),
    );
  }
}

class ShopSettingWidget extends StatelessWidget {
  final String? title;
  final String? icon;
  final bool? mode;
  final Function(bool value)? onTap;
  final Function()? onPress;
  final bool dateSelection;
  const ShopSettingWidget({Key? key, this.title, this.icon, this.mode, this.onTap, this.dateSelection = false, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopController>(
      builder: (context, shop,_) {
        return Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.125))),
          child: Row(children: [
            Expanded(child: Text(getTranslated(title, context)!,style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),)),
            dateSelection?
            InkWell(onTap: onPress ,
              child: Container(decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor, width: .25),
                  borderRadius: BorderRadius.circular(50)),
                child: Padding(padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text((shop.shopModel != null && shop.shopModel!.vacationStartDate != null) ? shop.shopModel!.vacationStartDate!:'${getTranslated('start_date', context)}'),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Icon(Icons.arrow_forward_rounded,size: Dimensions.iconSizeDefault,
                            color:  Theme.of(context).primaryColor)),
                      Text((shop.shopModel != null && shop.shopModel!.vacationEndDate != null)? shop.shopModel!.vacationEndDate! : '${getTranslated("end_date", context)}'),
                    ],
                  ),
                ),
              ),
            ):
            FlutterSwitch(
              value: mode!,
              width: 50,
              height: 27,
              activeColor: Theme.of(context).primaryColor,
              toggleSize: 20,
              padding: 2,
              onToggle: onTap!)

          ],),
        );
      }
    );
  }
}
