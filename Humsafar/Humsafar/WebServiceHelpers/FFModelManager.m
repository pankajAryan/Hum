//
//  FFModelManager.m
//  FabFurnish
//
//  Created by Amit Kumar on 19/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "FFModelManager.h"
#import "FFWebServiceHelper.h"


@implementation FFModelManager


+(FFModelManager*)sharedManager{
    
    static FFModelManager* sharedInstance;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[FFModelManager alloc] init];
    });
    
    return sharedInstance;
}


-(void)startProgress:(UIColor *)color
{
    [self stopProgress];
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FFProgress" owner:nil options:nil];
    UIView *View = [nibContents lastObject];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _HUD = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    
    if (color) {
        [_HUD setColor:color];
    }
    
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = nil;
    _HUD.detailsLabelText = nil;
    _HUD.customView = View;
    [_HUD show:YES];
}

-(void)stopProgress
{
    if (![_HUD isHidden]) {
        [_HUD hide:YES];
    }
}

#pragma mark- Fetch JSON With URL

- (void)fetchJSONFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id object))fetchedBlock
{
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            //[self updateSessionWithDictionary:response];
            fetchedBlock(eResponseTypeSuccessJSON,response);
        }else{
            fetchedBlock(responseType,response);
        }
    }];
}

/*
#pragma mark- Fetch Teasers

-(void) fetchTeasers:(void(^)(eResponseType type, id object))fetchedBlock;
{
        [self callWebServiceWithUrl:HOME_PAGE withParameter:nil onCompletion:^(eResponseType responseType, id response) {

            if (responseType == eResponseTypeSuccessJSON) {
                FFTeaserBaseClass *teaserData = [[FFTeaserBaseClass alloc] initWithDictionary:response];
                fetchedBlock(eResponseTypeModel, teaserData);
            }else{
                fetchedBlock(responseType, response);
            }
        }];
}

#pragma mark- Fetch LeftMenuOrCategories

-(void) fetchCategories:(void(^)(eResponseType type, id object))fetchedBlock
{
    [self callWebServiceWithUrl:CATEGORIES withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            FFCategoriesBaseClass *categories = [[FFCategoriesBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel,categories);
        }else{
            fetchedBlock(responseType,response);
        }
    }];
}


#pragma mark- Fetch Web View Data URL
// Correct this method
-(void) fetchWebViewDataFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id object))fetchedBlock
{
    [self startProgress:nil];
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            [self updateSessionWithDictionary:response];
            NSString *HtmlString = [[response objectForKey:@"metadata"] objectForKey:@"data"];
            NSString *baseUrl = [[response objectForKey:@"metadata"] objectForKey:@"base_url"];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:HtmlString,@"html",baseUrl,@"baseUrl", nil];
            
            fetchedBlock(eResponseTypeSuccessJSON,dict);
        }else{
            fetchedBlock(responseType,response);
        }
        [self stopProgress];
        
    }];
}

#pragma mark - Login/Register
-(void)loginWithParameter:(NSMutableDictionary *)paramDic withLoginType:(eUserLoginType )loginType showProgressHud:(BOOL)showLoadingIndicator responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock
{
    NSString *urlString = loginType==eUserLoginTypeFabFurnish ? LOGIN : SOCIAL_LOGIN;
    if (showLoadingIndicator)
        [self startProgress:nil];
    
    [self callWebServiceWithUrl:urlString withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFUserProfileBaseClass *userProfile = [[FFUserProfileBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, userProfile);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}
/*
-(void)socialLoginWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock
{
    [self startProgress:nil];
    [self callWebServiceWithUrl:SOCIAL_LOGIN withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFUserProfileBaseClass *userProfile = [[FFUserProfileBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, userProfile);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

-(void) customerLoginWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:LOGIN withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFUserProfileBaseClass *userProfile = [[FFUserProfileBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, userProfile);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

#pragma mark - forgetPasswordWithParam

-(void) forgetPasswordWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:FORGOT_PASS withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            [self updateSessionWithDictionary:response];
        }
        responseBlock(responseType, response);

        [self stopProgress];
        
    }];
}


#pragma mark- Logout
-(void) customerLogoutWithResponseBlock:(void(^)(eResponseType type, id userProfile))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:CUSTOMER_LOGOUT withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFUserProfileBaseClass *loggedOutProfile = [[FFUserProfileBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, loggedOutProfile);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}


#pragma mark- Create Account

-(void) createAccountWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:REGISTER withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFUserProfileBaseClass *userProfile = [[FFUserProfileBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, userProfile);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

#pragma mark- Add To Cart

-(void) addItemToCartWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock{
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (NSString *key in [paramDic allKeys]) {
        
        [arr addObject:[NSString stringWithFormat:@"%@=%@",key,paramDic[key]]];
    }
    
    NSString *paramsStr = [arr componentsJoinedByString:@"&"];
    
    arr = nil;
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:[NSString stringWithFormat:@"%@?%@",ADD_PRODUCT,paramsStr] withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCartBaseClass *cartModal = [[FFCartBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, cartModal);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

#pragma mark - fetch My Orders List

-(void) fetchMyOrdersInResponseBlock:(void(^)(eResponseType type, id userProfile))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:MY_ORDER withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON || responseType == eResponseTypeFailJSON) {
            // We are considering fail response (success = false)
            // because in case of "No Record Found" we have to add a text Tag on screen with message "No Record Found"
            FFMyOrdersBaseClass *myOrders = [[FFMyOrdersBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, myOrders);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

#pragma mark- My Orders Details
-(void) fetchOrderDetailWithID:(NSString*)orderId responseBlock:(void(^)(eResponseType type, id orderDetails))responseBlock{
    
    [self startProgress:nil];
    // Create URL String
    NSString *orderDetailsURL = [NSString stringWithFormat:MY_ORDER_DETAIL,orderId];
    
    [self callWebServiceWithUrl:orderDetailsURL withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            FFOrderDetailBaseClass *orderDetails = [[FFOrderDetailBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, orderDetails);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

#pragma mark- Get Cart Data

-(void) getCartItemsWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:MYORDER withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCartBaseClass *cartModal = [[FFCartBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, cartModal);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

#pragma mark- Update Cart items Quantity

-(void) updateCartItemsQuantityWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock{
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (NSString *key in [paramDic allKeys]) {
        
        [arr addObject:[NSString stringWithFormat:@"%@=%@",key,paramDic[key]]];
    }
    
    NSString *paramsStr = [arr componentsJoinedByString:@"&"];
    
    arr = nil;
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:[NSString stringWithFormat:@"%@?%@",CART_CHANGE_QTY,paramsStr] withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCartBaseClass *cartModal = [[FFCartBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, cartModal);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

#pragma mark- Remove item from cart

-(void) removeItemFromCartWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock{
    
    NSMutableArray *arr = [NSMutableArray new];
    
    for (NSString *key in [paramDic allKeys]) {
        
        [arr addObject:[NSString stringWithFormat:@"%@=%@",key,paramDic[key]]];
    }
    
    NSString *paramsStr = [arr componentsJoinedByString:@"&"];
    
    arr = nil;
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:[NSString stringWithFormat:@"%@?%@",REMOVE_PRODUCT,paramsStr] withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCartBaseClass *cartModal = [[FFCartBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, cartModal);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

#pragma mark- Add Coupon Code To cart

-(void) addCouponCodeToCartWithParam:(NSString *)couponCode responseBlock:(void(^)(eResponseType type, id cartModal))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:[NSString stringWithFormat:@"%@%@",ADD_VOUCHER,couponCode] withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCartBaseClass *cartModal = [[FFCartBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, cartModal);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

#pragma mark- Remove Coupon Code From cart

-(void) removeCouponCodeFromCartWithResponseBlock:(void(^)(eResponseType type, id cartModal))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:REMOVE_VOUCHER withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCartBaseClass *cartModal = [[FFCartBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, cartModal);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

#pragma mark- Search
-(void) searchSuggestionWithString:(NSString *)string responseBlock:(void(^)(eResponseType type, id suggestion))responseBlock
{
    [self.reqOperation cancel];
//    [self startProgress:nil];
    [self callWebServiceWithUrl:[NSString stringWithFormat:URL_SUGGESTION,string] withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFSuggestionBaseClass *catalog = [[FFSuggestionBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, catalog);
        }else{
            responseBlock(responseType, response);
        }
//        [self stopProgress];
        
    }];
    
}

#pragma mark- Add Gift Wrap
-(void) addGiftWrapWithParam:(NSMutableDictionary *)ParamDic responseBlock:(void(^)(eResponseType type, id suggestion))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:ADD_GIFT_WRAP withParameter:ParamDic onCompletion:^(eResponseType responseType, id response) {

        if (responseType == eResponseTypeSuccessJSON) {
            [self updateSessionWithDictionary:response];
        }
        responseBlock(responseType, response);
        
        [self stopProgress];
    }];
}

#pragma mark- Remove Gift Wrap
-(void) removeGiftRwapWithResponseBlock:(void(^)(eResponseType type, id suggestion))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:REMOVE_GIFT_WRAP withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            [self updateSessionWithDictionary:response];
        }
        
        responseBlock(responseType, response);
        
        [self stopProgress];
    }];
}

#pragma mark- EMI POP-UP
-(void) emiPopUpWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:EMI_POP withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFEMIOptionBaseClass *emiOptionModal = [[FFEMIOptionBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, emiOptionModal);
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

#pragma mark- Track Order
-(void)trackOrderWithParam:(NSMutableDictionary *)ParamDic responseBlock:(void(^)(eResponseType type, id response))responseBlock
{
    [self startProgress:nil];
    [self callWebServiceWithUrl:TRACK_ORDER withParameter:ParamDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFTrackOrderBaseClass *trackModal = [[FFTrackOrderBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, trackModal);
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];

    
}


#pragma mark - Change Password
-(void) changePassword:(NSMutableDictionary*)param inResponseBlock:(void(^)(eResponseType type, id userProfile))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:CHANGE_PASS withParameter:param onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            [self updateSessionWithDictionary:response];
            responseBlock(responseType, response);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

#pragma mark - Fetch State List
-(void) fetchListOfStateInResponseBlock:(void(^)(eResponseType type, id response))responseBlock{
    [self startProgress:nil];
    [self callWebServiceWithUrl:GET_REGION withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            FFRegionListBaseClass *region = [[FFRegionListBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, region);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}


#pragma mark - Find City And State
-(void) fetchCityAndStateOfPin:(NSString*)pincode inResponseBlock:(void(^)(eResponseType type, id response))responseBlock{
    NSString *pincodeURL = [NSString stringWithFormat:GET_CITY_STATE_BY_PIN,pincode];
    [self startProgress:nil];
    [self callWebServiceWithUrl:pincodeURL withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            [self updateSessionWithDictionary:response];
            responseBlock(responseType, response);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

#pragma mark - Add New Address
-(void) addNewAddress:(NSMutableDictionary*)param inResponseBlock:(void(^)(eResponseType type, id response))responseBlock{
    [self startProgress:nil];
    [self callWebServiceWithUrl:ADD_ADDRESS withParameter:param onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            [self updateSessionWithDictionary:response];
            
            responseBlock(responseType, response);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

#pragma mark - subscribe/unsubscribe News Letter

-(void) subscribeUnsubscribeNewsLetterWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:CUSTOMER_NEWSLETTER withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFSubscribesBaseClass *subscribe = [[FFSubscribesBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, subscribe);
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

#pragma mark- last Success Checkout Order 
-(void) lastSuccessCheckOutDetailWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:SUCCESS_ORDER withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
        
            FFCheckoutOrderBaseClass *checkoutModal = [[FFCheckoutOrderBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, checkoutModal);
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

#pragma mark- last failure checkout data

-(void) lastFailureCheckOutDetailWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:ERROR_ORDER withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            [self updateSessionWithDictionary:response];
            
            responseBlock(eResponseTypeModel, response[kKEY_metadata]);
            
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}


#pragma mark - Fetch Reward and Credit Point

-(void) rewardAndCreditPointInResponseBlock:(void(^)(eResponseType type, id response))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:REWRAD_CREDIT_POINTS withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            FFPointsBaseClass *points = [[FFPointsBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, points);
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

#pragma mark - Get user profile data

-(void) getLoggedInUserProfileDataBlock:(void(^)(eResponseType type, id response))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:CUSTOMER_DETAIL withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            FFUserProfileBaseClass *userProfile = [[FFUserProfileBaseClass alloc] initWithDictionary:response];

            responseBlock(eResponseTypeModel, userProfile);
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}


#pragma mark- Contacts US

-(void)contactusResponseBlock:(void(^)(eResponseType type, id response))responseBlock
{
    [self startProgress:nil];
    [self callWebServiceWithUrl:[NSString stringWithFormat:@"%@%@",APP_CMS,CONTACTUS_API] withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            
            FFContactusBaseClass *contactus = [[FFContactusBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, contactus);
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

#pragma mark- Why Fab-furnuish

-(void)whyFabFurnishResponseBlock:(void(^)(eResponseType type, id response))responseBlock
{
    [self startProgress:nil];
    [self callWebServiceWithUrl:[NSString stringWithFormat:@"%@%@",APP_CMS,WHYFABFURNISH_API] withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            
            FFContactusBaseClass *whyFab = [[FFContactusBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, whyFab);
        }else{
            responseBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

#pragma mark- Product Catalogue & PDP Module

-(void) fetchCatalogFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id data))fetchedBlock Progress:(BOOL)isProgress
{
    if (isProgress) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            
            NSString *layout = [response objectForKey:@"layout_type"];
            if ((layout != nil)&&([layout compare:@"microsite" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
                
                fetchedBlock(eResponseTypeSuccessJSON, response);
            }
            else {
                FFCatalogcatalog *catalog = [[FFCatalogcatalog alloc] initWithDictionary:response];
                fetchedBlock(eResponseTypeModel, catalog);
            }
            
        }else{
            fetchedBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

-(void) fetchFilterFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id data))fetchedBlock Progress:(BOOL)isProgress
{
    
    if (isProgress) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCatalogcatalog *catalog = (FFCatalogcatalog*)[[FFCatalogcatalog alloc]initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, catalog);
        }else{
            fetchedBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

- (void)fetchPDPFromURL:(NSString *)urlString fetched:(void(^)(eResponseType type, id data))fetchedBlock
{
    
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFPDPBaseClass *pdp = [[FFPDPBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, pdp);
        }else{
            fetchedBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

- (void)getColorOptions:(NSString *)urlString progressHud:(BOOL)show fetched:(void(^)(eResponseType type, id data))fetchedBlock
{
    if (show) {
        [self startProgress:nil];
    }

    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFProductColorBaseClass *colorGroupBaseModel = [[FFProductColorBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel,colorGroupBaseModel);
        }else{
            fetchedBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

- (void)getProductGroup:(NSString *)urlString progressHud:(BOOL)show fetched:(void(^)(eResponseType type, id data))fetchedBlock
{
    if (show) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFProductGroupBaseClass *productGroupBaseModel = [[FFProductGroupBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, productGroupBaseModel);
        }else{
            fetchedBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

// Product available at pincode
-(void) productAvailabilityAtPincodeWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, NSArray *shippingInfoArr))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:PRODUCT_AVAILABLE_AT_PINCODE withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            
            NSMutableArray *parsedFFPDPShippingInfo = [NSMutableArray array];
            
            if ([response isKindOfClass:[NSDictionary class]]) {
                
                if (response[kKEY_metadata]) {
                    if (response[kKEY_metadata][kKEY_data]) {
                        
                        for (NSDictionary *item in response[kKEY_metadata][kKEY_data]) {
                            
                            if ([item isKindOfClass:[NSDictionary class]]) {
                                
                                [parsedFFPDPShippingInfo addObject:[FFPDPShippingInfo modelObjectWithDictionary:item]];
                            }
                        }
                    }
                }
            }
            
            [self updateSessionWithDictionary:response];
            responseBlock(eResponseTypeModel, parsedFFPDPShippingInfo);
            
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

- (void)sendDetailsToAddressPopupAPI:(NSString*)simpleSKU logFor:(NSString*)mode source:(NSString*)showroomId {

    NSString *urlString = [NSString stringWithFormat:@"%@deviceId=%@&sku=%@&mode=%@&showroomId=%@",API_ADDRESS_DISPLAY_LOG,deviceID,simpleSKU,mode,showroomId];
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            
            [self updateSessionWithDictionary:response];

            //DDLogDebug(@"On Display Log details submitted successfully.");
        }else{
            DDLogDebug(@"source submit failed.");
        }
    }];
}

//Submit review
-(void) submitReviewWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id userProfile))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:API_SUBMIT_REVIEWS withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            responseBlock(eResponseTypeSuccessJSON, response);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}
//=======================================================================================================

#pragma mark- Design & Inspiration Module WebServices

#pragma mark- Fab Ideas Module
- (void)fetchFabIdeasFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock
{
    if (isProgress) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFIdeasBaseClass *fabIdeasBase = [[FFIdeasBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, fabIdeasBase);
        }else{
            fetchedBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

- (void)fetchQuesAndCommentsFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress
                    fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock
{
    if (isProgress) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCommentsBaseClass *commentsBase = [[FFCommentsBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, commentsBase);
        }else{
            fetchedBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

- (void)postUserQuestionWithParams:(NSMutableDictionary*)params fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock
{
    [self startProgress:nil];
    
    [self callWebServiceWithUrl:API_SEND_FAQ withParameter:params onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            //FFCommentsBaseClass *commentsBase = [[FFCommentsBaseClass alloc] initWithDictionary:response];
            [self updateSessionWithDictionary:response];

            fetchedBlock(eResponseTypeSuccessJSON, response);
        }else{
            fetchedBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

//#pragma mark - Book Design Services
-(void) fetchDesignServiceInResponseBlock:(void(^)(eResponseType type, id userProfile))responseBlock{
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:API_BOOK_DESIGN withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON || responseType == eResponseTypeFailJSON) {
            // We are considering fail response (success = false)
            // because in case of "No Record Found" we have to add a text Tag on screen with message "No Record Found"
            FFBookDesignServiceBaseClass *bookDesign = [[FFBookDesignServiceBaseClass alloc]initWithDictionary:response];
            responseBlock(eResponseTypeModel, bookDesign);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
    }];
}

- (void)bookServiceWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock {
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:API_BOOK_SERVICE withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            responseBlock(eResponseTypeSuccessJSON, response);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}

#pragma mark- Fab Advice Module
- (void)fetchFabAdvicesFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock
{
    if (isProgress) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFAdviceBaseClass *fabAdviceBase = [[FFAdviceBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, fabAdviceBase);
        }else{
            fetchedBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

- (void)makeAppointmentWithParam:(NSMutableDictionary *)paramDic responseBlock:(void(^)(eResponseType type, id response))responseBlock {
    
    [self startProgress:nil];
    [self callWebServiceWithUrl:API_MAKE_APPOINTMENT withParameter:paramDic onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
//            FFUserProfileBaseClass *userProfile = [[FFUserProfileBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeSuccessJSON, response);
        }else{
            responseBlock(responseType, response);
        }
        [self stopProgress];
        
    }];
}


#pragma mark- Curators Module
- (void)fetchCuratorsFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock
{
    if (isProgress) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCuratorsBaseClass *curatorsBase = [[FFCuratorsBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, curatorsBase);
        }else{
            fetchedBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

- (void)fetchCuratorDetailsFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock
{
    if (isProgress) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFCuratorDetailBaseClass *curatorDetailBase = [[FFCuratorDetailBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, curatorDetailBase);
        }else{
            fetchedBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}


#pragma mark- Idea-Book Module
- (void)fetchIdeaBookDataFromURL:(NSString *)urlString progressIndicator:(BOOL)isProgress  fetchedResponse:(void(^)(eResponseType type, id data))fetchedBlock
{
    if (isProgress) {
        [self startProgress:nil];
    }
    
    [self callWebServiceWithUrl:urlString withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFIdeaBookBaseClass *ideaBookBase = [[FFIdeaBookBaseClass alloc] initWithDictionary:response];
            fetchedBlock(eResponseTypeModel, ideaBookBase);
        }else{
            fetchedBlock(responseType, response);
        }
        
        [self stopProgress];
    }];
}

#pragma mark - get cities
- (void)citySuggestionWithString:(NSString *)string requestType:(FFWebServiceType)type showLoading:(BOOL)show responseBlock:(void(^)(eResponseType type, id suggestion))responseBlock
{
    [self.reqOperation cancel];
    
    if (show)
        [self startProgress:nil];
    
    NSString *webServiceUrl = nil;
    if (type == FFWebServiceTypeNearbyShowrooms)// FFWebServiceTypeNearbyShowrooms,
    {
        webServiceUrl = [NSString stringWithFormat:URL_CITY_SUGGESTION,string];
    }
    else   //FFWebServiceTypeLocationInfo
        webServiceUrl = API_LOCATION_BY_GPS;
    
    [self callWebServiceWithUrl:webServiceUrl withParameter:nil onCompletion:^(eResponseType responseType, id response)
    {
        
        if (responseType == eResponseTypeSuccessJSON) {
            FFSelectCityBaseClass *cityData = [[FFSelectCityBaseClass alloc] initWithDictionary:response];
            responseBlock(eResponseTypeModel, cityData);
        }else{
            responseBlock(responseType, response);
        }

        if (show)
            [self stopProgress];
        
    }];
}
*/
//#pragma mark - nearby showrooms
//- (void)nearByShowroomsWithString:(NSString *)string responseBlock:(void(^)(eResponseType type, id suggestion))responseBlock
//{
//    [self.reqOperation cancel];
//    //    [self startProgress:nil];
//#warning string not joined to url.
//    [self callWebServiceWithUrl:[NSString stringWithFormat:API_SHOWROOMS,string] withParameter:nil onCompletion:^(eResponseType responseType, id response) {
//        
//        if (responseType == eResponseTypeSuccessJSON) {
//            FFSelectCityBaseClass *cityData = [[FFSelectCityBaseClass alloc] initWithDictionary:response];
//            responseBlock(eResponseTypeModel, cityData);
//        }else{
//            responseBlock(responseType, response);
//        }
//        //        [self stopProgress];
//        
//    }];
//}

@end
