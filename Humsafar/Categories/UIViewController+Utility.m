//
//  UIViewController+Utility.m
//  FabFurnish
//
//  Created by Pankaj Yadav on 07/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "UIViewController+Utility.h"
#import "FFConstant.h"
#import "TSMessage.h"

 
@implementation UIViewController (Utility)

+ (instancetype)instantiateViewControllerWithIdentifier:(NSString*)sceneId fromStoryboard:(NSString*)storyboardName {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:sceneId];
    
    return viewController;
}

+(BOOL)isNetworkAvailable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"There iS NO internet connection");
        return false;
        
    } else {
        
        NSLog(@"There iS internet connection available");
        return true;
    }
    return false;
}

- (void)showProgressHudWithMessage:(NSString*)message {
    
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = message;
    HUD.detailsLabelText = @"Please wait...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.tag = 501;
    [self.view addSubview:HUD];
    [HUD show:YES];
}


- (void)removeProgressHudAfterDelay:(NSTimeInterval)delay {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD*  HUD = (MBProgressHUD*)[self.view viewWithTag:501];
        if(HUD !=nil)
        {
            [HUD hide:YES afterDelay:delay];
            HUD = nil;
        }
    });
}

#pragma mark- Error And Alert Messages

-(void) showErrorTSMessage:(NSString*)errorMessage{
    [TSMessage showNotificationWithTitle:errorMessage type:TSMessageNotificationTypeError];
}
-(void) showSuccessTSMessage:(NSString*)errorMessage{
    [TSMessage showNotificationWithTitle:errorMessage type:TSMessageNotificationTypeSuccess];
}
-(void) showWarningTSMessage:(NSString*)errorMessage{
    [TSMessage showNotificationWithTitle:errorMessage type:TSMessageNotificationTypeWarning];
}

-(void) showResponseErrorWithType:(eResponseType)responseType responseObject:(id)object errorMessage:(NSString*)errorMessage{
    // handle error here, it will handle all negative response found in child class.
    
    if (errorMessage) {
        [TSMessage showNotificationWithTitle:errorMessage type:TSMessageNotificationTypeError];
    }else{
        
        switch (responseType) {
                
            case eResponseTypeModel :
                //This Case will never be executed. No Need to display message;
                break;
            case eResponseTypeSuccessJSON:
                // This Case will never be executed. No Need to display message;
                break;
                
            case eResponseTypeFailJSON:
            {
                NSDictionary *response = (NSDictionary *)object;
                NSString *message = [response objectForKey:kKEY_ErrorMessage];
                [TSMessage showNotificationWithTitle:message type:TSMessageNotificationTypeError];
            }
                break;
            case eResponseTypeNotJSON:
            {
                [TSMessage showNotificationWithTitle:@"Response is not Readable !!" type:TSMessageNotificationTypeError];
            }
                break;
            case eResponseTypeEmptyJSON:
            {
                [TSMessage showNotificationWithTitle:@"Response is Empty !!" type:TSMessageNotificationTypeError];
            }
                break;
            case eResponseTypeRequestFailure:
            {
                
                NSError *error = (NSError *)object;
                switch (error.code) {
                    case 1001: // Some Error
                    {
                        [TSMessage showNotificationWithTitle:@"Error !!" subtitle:[NSString stringWithFormat:@"%@",error.localizedDescription] type:TSMessageNotificationTypeError];
                    }
                        break;
                        
                    default:
                    {
                        [TSMessage showNotificationWithTitle:@"Error !!" subtitle:[NSString stringWithFormat:@"%@",error.localizedDescription] type:TSMessageNotificationTypeError];
                    }
                        break;
                }
                NSLog(@"%ld,%@,%@ - ",(long)error.code,error.description,error);
            }
                break;
            case eResponseTypeNULL:
            {
                [TSMessage showNotificationWithTitle:@"Response is Incomplete !!" type:TSMessageNotificationTypeError];
            }
                break;
            case eResponseTypeIncomplete:
            {
                [TSMessage showNotificationWithTitle:@"Response is Incomplete !!" type:TSMessageNotificationTypeError];
            }
                break;
            case eResponseTypeWaiting:
                //break;
            case eResponseTypeUnknown:
                //break;
                
            default:
            {
                [TSMessage showNotificationInViewController:self title:nil subtitle:@"Error !!" type:TSMessageNotificationTypeError duration:2 canBeDismissedByUser:YES];
                NSLog(@"Error-default: - %@",object);
            }
                break;
        }
    }
}

//-(void) showValidationError:(FFValidationResult*)validationError
//{
//    [TSMessage showNotificationWithTitle:validationError.errorMessage type:TSMessageNotificationTypeError];
//}


#pragma mark- UIAlertView Display Methods
#pragma mark-

- (void)showAlert:(NSString *)message{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (void)showCancelAlert:(NSString *)message {
    
    [self showCancelAlertWithTitle:message message:nil alertTag:0];
}

- (void)showCancelAlertWithTitle:(NSString *)title message:(NSString *)message alertTag:(NSInteger)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"NO",@"YES",nil];
    alertView.tag = tag;
    [alertView show];
}


- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}



- (void)showDelegatedAlertwithTitle:(NSString*)Title message:(NSString*)message tag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title
                                                      message:message
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}


@end
