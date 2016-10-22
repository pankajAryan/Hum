//
//  OTPViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 23/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "OTPViewController.h"
#import "RootViewController.h"

@interface OTPViewController ()

@property (weak, nonatomic) IBOutlet UITextField *otpTextField;
@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_otpTextField becomeFirstResponder];
}

- (IBAction)resendOTP:(id)sender {
    
    [self showProgressHudWithMessage:@"Resending OTP"];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:RegenerateOtp
                                                withParameter:@{@"mobileNumber":_mobileNumber}
                                                 onCompletion:^(eResponseType responseType, id response)
                                                {
                                                    [self hideProgressHudAfterDelay:0.1];
                                                    
                                                    if (responseType == eResponseTypeSuccessJSON) {
                                                        // OTP sent successfully
                                                    }else{
                                                        [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                                                        // [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                                                    }
                                                }];
}

- (IBAction)verifyOTP:(id)sender {
    
    [self showProgressHudWithMessage:@"Verifying OTP"];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:VerifyOtp withParameter:@{@"mobileNumber":_mobileNumber, @"otp":_otpTextField.text} onCompletion:^(eResponseType responseType, id response)
     {
         [self hideProgressHudAfterDelay:0.1];
         
         if (responseType == eResponseTypeSuccessJSON) {
             
             [_otpTextField resignFirstResponder];
             
             RootViewController *VC = [RootViewController instantiateViewControllerWithIdentifier:@"RootViewController" fromStoryboard:@"Main"];
             
             [self.navigationController pushViewController:VC animated:YES];
             
         }else{
             [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
             // [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
