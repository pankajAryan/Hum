//
//  Constant.h
//  FabFurnish
//
//  Created by Avneesh.minocha on 04/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//
// This class is use to define all constants values any string, number, color, DeviceID, etc.



#ifndef FabFurnish_Constant_h
#define FabFurnish_Constant_h

#import "AppDelegate.h"


#pragma mark - UI page Layouts

// Design & Inspiration
#define kFFFabIdeasLayout       @"fab-ideas"
#define kFFFabAdviceLayout      @"fab-advice"
#define kFFCuratorsLayout       @"curators"
#define kFFIdeaBookLayout       @"ideabook"
#define kFFIdeaDetailLayout     @"ideadetail"
#define kFFCuratorDetailLayout  @"curatordetail"

// Other layouts
#define kFFCatalogLayout        @"catalog"
#define kFFPDPLayout            @"pdp"
#define kFFWebViewLayout        @"webview"
#define kFFWebviewFromUrlLayout @"webview_layout"
#define kFFBlogLayout           @"blog"
#define kFFExternalLinkLayout   @"external"

#define kFFCartLayout           @"cart"
#define kFFLoginLayout          @"login"
#define kFFRegisterLayout       @"register"


//Dictionary constant which is useful in push 'view controller utility'
#define KSearchQuery        @"searchQuery"
#define KScreenComingFrom   @"screenComingFrom"
#define KModelObject        @"modelObject"


#pragma mark - Deeplinking & APNS payload keys
// Sorting & Filter/otherCustomQuery implementation through deeplink url.
#define KSortFlag           @"sortflag"
#define KUrlQueryString     @"qstring"

#define KSource             @"source"
#define KSourceId           @"sourceId"
#define KScreenTitle        @"screenTitle"



#pragma mark - iOS SDK Methods

#define SharedModelManager [FFModelManager sharedManager]
#define App_Delegate (AppDelegate*)[[UIApplication sharedApplication] delegate]

//*********************************CONSTANTS********************************************

#pragma mark - Device constants
#define deviceID   [[UIDevice currentDevice] identifierForVendor].UUIDString

#define iPhone4 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 480)

#define iPhone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 568)

#define iPhone6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)

#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width


//********|| Public Enumerations ||*********** //
#pragma mark- Public Enums
typedef NS_ENUM(NSUInteger, FFCatalogType) {
    FFCatalogTypeDefault,
    FFCatalogTypeShopTheLook,
};

typedef enum : NSUInteger {
    eFilterTypeRadioButton,
    eFilterTypeCheckbox,
} eFilterType;



/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//************************************END********************************************


//***************************** NSLocalizedString ***************************************

#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

//************************************END********************************************


#pragma mark - Constant Strings
//*********************************|| Constant Strings ||*******************************
 
#define kSHARE_EMAIL_SUBJECT NSLocalizedString(@"kSHARE_EMAIL_SUBJECT", nil)

#define kSHARE_APP_SUBJECT NSLocalizedString(@"kSHARE_APP_SUBJECT", nil)

#define kSHARE_APP_BODY_TEXT NSLocalizedString(@"kSHARE_APP_BODY_TEXT", nil)

//************************************END********************************************


#pragma mark - Alert messages
//*********************************ALERT********************************************

#define kMessageMaintenanceFailure NSLocalizedString(@"kMessageMaintenanceFailure", nil)

#define kMessageInternetFailure NSLocalizedString(@"kMessageInternetFailure", nil)
#define kMessageUpdateApp NSLocalizedString(@"kMessageUpdateApp", nil)
#define kMessageSelectAVariant  NSLocalizedString(@"kMessageSelectAVariant", nil)

#define kMessagePlzEntrCouponCode  NSLocalizedString(@"kMessagePlzEntrCouponCode", nil)

#define kMessageEnterPincode  NSLocalizedString(@"kMessageEnterPincode", nil)
#define kMessagePlzEnterMessage  NSLocalizedString(@"kMessagePlzEnterMessage", nil)
#define kMessagePlzEnterSenderName  NSLocalizedString(@"kMessagePlzEnterSenderName", nil)
#define kMessagePlzEnterReceiverName  NSLocalizedString(@"kMessagePlzEnterReceiverName", nil)
#define kMessageSelectBankFirst  NSLocalizedString(@"kMessageSelectBankFirst", nil)
#define kMessageEnterOrderTrackID  NSLocalizedString(@"kMessageEnterOrderTrackID", nil)
#define kMessagePasswordChanged  NSLocalizedString(@"kMessagePasswordChanged", nil)
#define kMessageCouldNotSubscribe  NSLocalizedString(@"kMessageCouldNotSubscribe", nil)
#define kMessageYouAreNotLogin  NSLocalizedString(@"kMessageYouAreNotLogin", nil)
#define kMessageYouHavePlacedNoOrders  NSLocalizedString(@"kMessageYouHavePlacedNoOrders", nil)

#define kMessageEmptyQuesCommentAlert  NSLocalizedString(@"kMessageEmptyQuesCommentAlert", nil)


#pragma mark - Login Screen

#define kMessageNoEmailEntered NSLocalizedString(@"kMessageNoEmailEntered", nil)
#define kMessagePasswordEmpty NSLocalizedString(@"kMessagePasswordEmpty", nil)
#define kMessagePasswordSentOnMail  NSLocalizedString(@"kMessagePasswordSentOnMail", nil)
#define kMessageEmailIdNotRegister  NSLocalizedString(@"kMessageEmailIdNotRegister", nil)

//**********************************END********************************************

#pragma mark - Enums

typedef NS_ENUM(NSUInteger, kProductImageCellType) {
    kProductImageCellTypeProductDetail,
    kProductImageCellTypeTopBanners
};

// Network's Responce Type
typedef enum {
    eResponseTypeModel = 1, // fetch JSON data converted into Model
    eResponseTypeSuccessJSON, //API Response with "success = true"
    eResponseTypeFailJSON, //API Response with "success = false"
    eResponseTypeNotJSON, // Response is not in form of JSON
    eResponseTypeEmptyJSON, // Response is empty = {} // Reserverd
    eResponseTypeRequestFailure, // failure block is called in AFNetworking response
    eResponseTypeNULL, // nil Response
    eResponseTypeIncomplete, // Reserved
    eResponseTypeWaiting, // Reserved
    eResponseTypeUnknown // Reserved
} eResponseType;

typedef NS_ENUM(NSUInteger, kProductDetailScreenComingFrom) {
    kComingFromCatalogue,
    kComingFromCart,
    kComingFromWishList,
    KComingFromQRcodeScanner,
    kComingFromHome,
    kComingFromPDP_ProductFamily,
};

typedef NS_ENUM(NSUInteger, kTabItemType) {
    kTabItemTypeWishList,
    kTabItemTypeCart,
};


typedef NS_ENUM(NSUInteger, kPoppedControllerType) {
    kPoppedControllerTypeOrderDetails,
};

typedef NS_ENUM(NSUInteger, FabDesignsInvokerActionType) {
    invokerActionTypeDefault,
    invokerActionTypeRelatedLooks,
    invokerActionTypeFeaturedLayout
};


#endif

// We will add it in a seperate file which will have only keys of JSON.
#pragma mark- Temporary Constants

#define kFFPostNotification_HandlePushInTerminateState      @"kFFPostNotification_HandlePushInTerminateState"
#define kFFPostNotification_WishListItemsChange             @"kFFPostNotification_WishListItemsChange"
#define kFFPostNotification_LocationChangedByUser           @"kFFPostNotification_LocationChangedByUser"


#define kKEY_ErrorCode @"errorCode"
#define kKEY_ErrorMessage @"errorMessage"
#define kKEY_ResponseObject @"responseObject"

#define kKEY_version_severity @"version_severity"
#define kKEY_version_code @"version_code"

#define kKEY_city @"city"
#define kKEY_state @"state"

// Device info token
#define kKEY_device_id @"device_id"
#define kKEY_pushNotificationToken @"notification_id"
#define kKEY_uuid @"uuid"
#define kKEY_type @"type"
#define kKEY_version_code @"version_code"
#define kKEY_version_name @"version_name"
#define kKEY_brand @"brand"
#define kKEY_ip_address @"ip_address"
#define kKEY_model @"model"
#define kKEY_DEVICEDETAILS @"devicedetails"
#define kKY_SELECTED_CITY @"selected_city"

#pragma Login And Register
//common
#define kVALUE_1 @"1"
#define kVALUE_0 @"0"
#define kVALUE_Male @"Male"
#define kVALUE_Female @"Female"
#define kKEY_loginType @"loginType"

#define kKEY_Login_Params @"socialLoginParams"

// Login
#define kKEY_LoginForm_email @"LoginForm[email]"
#define kKEY_LoginForm_password @"LoginForm[password]"
// Register
#define kKEY_RegistrationForm_gender                                @"RegistrationForm[gender]"
#define kKEY_RegistrationForm_email                                 @"RegistrationForm[email]"
#define kKEY_RegistrationForm_first_name                            @"RegistrationForm[first_name]"
#define kKEY_RegistrationForm_last_name                             @"RegistrationForm[last_name]"
#define kKEY_RegistrationForm_birthday                              @"RegistrationForm[birthday]"
#define kKEY_RegistrationForm_ip                                    @"RegistrationForm[ip]"
#define kKEY_RegistrationForm_reg_type                              @"RegistrationForm[reg_type]"
#define kKEY_RegistrationForm_is_newsletter_subscribed              @"RegistrationForm[is_newsletter_subscribed]"
#define kKEY_RegistrationForm_contact_number                        @"RegistrationForm[contact_number]"
#define kKEY_RegistrationForm_password                              @"RegistrationForm[password]"

