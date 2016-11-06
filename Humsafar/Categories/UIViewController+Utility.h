//
//  UIViewController+Utility.h
//  FabFurnish
//
//  Created by Pankaj Yadav on 07/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FFValidationResult.h"
#import "FFConstant.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface UIViewController (Utility)

+ (instancetype)instantiateViewControllerWithIdentifier:(NSString*)storyBoardId fromStoryboard:(NSString*)storyboardName;

- (void)showProgressHudWithMessage:(NSString*)message;

- (void)hideProgressHudAfterDelay:(NSTimeInterval)delay;

+(BOOL)isNetworkAvailable;

+(void)saveDatatoUserDefault:(id)data forKey:(NSString*)key;
+(id)retrieveDataFromUserDefault:(NSString*)key;

-(void) showErrorTSMessage:(NSString*)errorMessage;
-(void) showWarningTSMessage:(NSString*)errorMessage;
-(void) showSuccessTSMessage:(NSString*)errorMessage;

-(void) showResponseErrorWithType:(eResponseType)responseType responseObject:(id)object errorMessage:(NSString*)errorMessage;
//-(void) showValidationError:(FFValidationResult*)validationError;

// UIAlertView Display Methods
-(void) showAlert:(NSString *)message;
-(void) showCancelAlert:(NSString *)message;
- (void)showCancelAlertWithTitle:(NSString *)title message:(NSString *)message alertTag:(NSInteger)tag;

- (void)showDelegatedAlertwithTitle:(NSString*)Title message:(NSString*)message tag:(NSInteger)tag;

+(void) showAlert:(NSString *)message;

+(NSString*)formattedDate:(NSString*)date;

@end
