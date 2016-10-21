//
//  FFModelManager.h
//  FabFurnish
//
//  Created by Amit Kumar on 19/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "FFWebServiceHelper.h"
#import "MBProgressHUD.h"

//#import "DataModels.h"

typedef NS_ENUM(NSUInteger, FFWebServiceType) {
    FFWebServiceTypeGeneric,
    FFWebServiceTypeNearbyShowrooms,
    FFWebServiceTypeLocationInfo,
};

@interface FFModelManager : FFWebServiceHelper

@property(nonatomic,strong)MBProgressHUD *HUD;

#pragma mark- Singleton
+(FFModelManager*)sharedManager;

#pragma mark- Progress Indicator
-(void)startProgress:(UIColor *)color;
-(void)stopProgress;

#pragma mark- Fetch JSON From URL
-(void) fetchJSONFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id object))fetchedBlock;
/*
#pragma mark- Home page
-(void) fetchTeasers:(void(^)(eResponseType type, id object))fetchedBlock;

#pragma mark- Product Catalogue & PDP Module

-(void) fetchCatalogFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id data))fetchedBlock Progress:(BOOL)isProgress;
-(void) fetchFilterFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id data))fetchedBlock Progress:(BOOL)isProgress;

-(void) fetchPDPFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id object))fetchedBlock;
- (void)getColorOptions:(NSString *)urlString progressHud:(BOOL)show fetched:(void(^)(eResponseType type, id data))fetchedBlock;
- (void)getProductGroup:(NSString *)urlString progressHud:(BOOL)show fetched:(void(^)(eResponseType type, id data))fetchedBlock;

#pragma mark- Fetch LeftMenuOrCategories
-(void) fetchCategories:(void(^)(eResponseType type, id object))fetchedBlock;

#pragma mark- Fetch Web View Data From  URL
-(void) fetchWebViewDataFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id object))fetchedBlock;

#pragma mark- CustomerLogin
-(void)loginWithParameter:(NSMutableDictionary *)paramDic withLoginType:(eUserLoginType )loginType showProgressHud:(BOOL)showLoadingIndicator responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock;

#pragma mark - forget password
-(void) forgetPasswordWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock;

#pragma mark- Logout
-(void) customerLogoutWithResponseBlock:(void(^)(eResponseType type, id userProfile))responseBlock;

#pragma mark- Create Account
-(void) createAccountWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock;

#pragma mark- Add to cart
-(void) addItemToCartWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock;

#pragma mark- Get cart items
-(void) getCartItemsWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock;

#pragma mark- Update Cart items Quantity
-(void) updateCartItemsQuantityWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock;

#pragma mark- Remove item from cart
-(void) removeItemFromCartWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock;

#pragma mark- Add Coupon Code To cart
-(void) addCouponCodeToCartWithParam:(NSString *)couponCode responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock;

#pragma mark- Remove Coupon Code From cart
-(void) removeCouponCodeFromCartWithResponseBlock:(void(^)(eResponseType type, id cartModal))responseBlock;

#pragma mark- Product available at pincode
-(void) productAvailabilityAtPincodeWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, NSArray *shippingInfoArr))responseBlock;
#pragma mark- My Orders
-(void) fetchMyOrdersInResponseBlock:(void(^)(eResponseType type, id myOrders))responseBlock;
#pragma mark- My Orders Details
-(void) fetchOrderDetailWithID:(NSString*)orderId responseBlock:(void(^)(eResponseType type, id orderDetails))responseBlock;

#pragma mark- Search
-(void) searchSuggestionWithString:(NSString *)string responseBlock:(void(^)(eResponseType type, id suggestion))responseBlock;

//#pragma mark- Social Login/Register
//-(void)socialLoginWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock;


#pragma mark- Add Gift Wrap
-(void) addGiftWrapWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark- Remove Gift Wrap
-(void) removeGiftRwapWithResponseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark- EMI POP-UP
-(void) emiPopUpWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark- last Success Checkout Order 
-(void) lastSuccessCheckOutDetailWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark- last failure checkout data
-(void) lastFailureCheckOutDetailWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark- Track Order
-(void)trackOrderWithParam:(NSMutableDictionary *)ParamDic responseBlock:(void(^)(eResponseType type, id response))responseBlock;


#pragma mark - Change Password
-(void) changePassword:(NSMutableDictionary*)param inResponseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark - Fetch State List
-(void) fetchListOfStateInResponseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark - City And State using Pincode
-(void) fetchCityAndStateOfPin:(NSString*)pincode inResponseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark - Add New Address
-(void) addNewAddress:(NSMutableDictionary*)param inResponseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark - subscribe/unsubscribe News Letter

-(void) subscribeUnsubscribeNewsLetterWithParam:(NSMutableDictionary *)param responseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark - Fetch Reward and Credit Point

-(void) rewardAndCreditPointInResponseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark - Get user profile data
-(void) getLoggedInUserProfileDataBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark- Contacts Us
-(void)contactusResponseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark- Why Fab-furnuish
-(void)whyFabFurnishResponseBlock:(void(^)(eResponseType type, id response))responseBlock;

-(void)sendDetailsToAddressPopupAPI:(NSString*)simpleSKU logFor:(NSString*)mode source:(NSString*)showroomId;


//===============================|| Design & Inspiration Module ||========================================//

#pragma mark- Design & Inspiration Module WebServices

#pragma mark- Fab Ideas Module
- (void)fetchFabIdeasFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock;
- (void)fetchQuesAndCommentsFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress
                    fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock;
- (void)postUserQuestionWithParams:(NSMutableDictionary*)params fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock;
//#pragma mark Book Design Services
-(void) fetchDesignServiceInResponseBlock:(void(^)(eResponseType type, id userProfile))responseBlock;
- (void)bookServiceWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock;


#pragma mark- Fab Advice Module
- (void)fetchFabAdvicesFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock;
-(void) makeAppointmentWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock;

#pragma mark- Curators Module
- (void)fetchCuratorsFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock;
- (void)fetchCuratorDetailsFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock;

#pragma mark- Idea-Book Module
- (void)fetchIdeaBookDataFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock;

#pragma mark - submit review
-(void) submitReviewWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock;

#pragma mark - get cities
- (void)citySuggestionWithString:(NSString *)string requestType:(FFWebServiceType)type showLoading:(BOOL)show responseBlock:(void(^)(eResponseType type, id suggestion))responseBlock;
*/
@end
