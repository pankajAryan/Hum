//
//  ProfileViewController2.m
//  Humsafar
//
//  Created by Rahul Chaudhary on 03/11/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "ProfileViewController2.h"
#import "UITextField+Validation.h"

@interface ProfileViewController2 ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *txtFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldConfirmPassword;

@end

@implementation ProfileViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.layer.cornerRadius = 28;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.imageView.layer.borderWidth = 3;

    self.txtFieldUsername.text = [UIViewController retrieveDataFromUserDefault:@"ssoId"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Button Actions

- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateButtonDidTap:(id)sender {
    
    if (_txtFieldPassword.isEmptyField || _txtFieldConfirmPassword.isEmptyField) {
        [self showAlert:@"Please enter Password!"];
    }else if (![_txtFieldPassword.text isEqualToString:_txtFieldConfirmPassword.text]){
        [self showAlert:@"Password does not match!"];
    }else {
        
        NSDictionary *paramsDict = @{@"userName": _txtFieldUsername.text, @"password": _txtFieldPassword.text};
        
        [self showProgressHudWithMessage:@"Updating profile.."];
        
        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:UpdateDepartmentUserProfile withParameter:paramsDict onCompletion:^(eResponseType responseType, id response) {
            
            [self hideProgressHudAfterDelay:0.1];
            
            if (responseType == eResponseTypeSuccessJSON)
            {
                [self showAlert:@"Profile updated successfully!"];
            }
            else {
                
                [self showAlert:@"Something went wrong!"];

//                if (responseType != eResponseTypeNoInternet)
//                {
//                    [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
//                }
            }
        }];
    }
}

@end
