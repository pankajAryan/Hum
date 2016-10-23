//
//  LoginViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UITextField+Validation.h"
#import "RootViewController.h"


@interface LoginViewController () <GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet GIDSignInButton *GSignIn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Login Actions

- (IBAction)loginButtonDidTap:(id)sender {
    
    if (_txtFieldUsername.isEmptyField || _txtFieldPassword.isEmptyField) {
        [self showAlert:@"All input fields are mandatory!"];
    }
//    else if (!_txtFieldUsername.isEmailValid) {
//        [self showAlert:@"Invalid Email address!"];
//    }
    else {
        
        NSDictionary *paramsDict = @{@"userName": _txtFieldUsername.text, @"password": _txtFieldPassword.text, @"deviceOS":@"iOS"};
        
        [self showProgressHudWithMessage:@"SigningIn"];
        
        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:departmentLogin withParameter:paramsDict onCompletion:^(eResponseType responseType, id response) {
            
            [self hideProgressHudAfterDelay:0.1];
            
            if (responseType == eResponseTypeSuccessJSON)
            {
                [UIViewController saveDatatoUserDefault:[response objectForKey:@"responseObject"] forKey:@"userId"];
                [UIViewController saveDatatoUserDefault:@"1" forKey:@"isUserLoggedIn"];

                RootViewController *VC = [RootViewController instantiateViewControllerWithIdentifier:@"RootViewController" fromStoryboard:@"Main"];
                
                [self.navigationController pushViewController:VC animated:YES];
            }
            else {
                if (responseType != eResponseTypeNoInternet)
                {
                    //[self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                    [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                }
            }
        }];
    }
}

- (IBAction)googleSignInButtonDidTap:(id)sender {
    // google Login
    [self setupGoogleLogin];
    //    [[GPPSignIn sharedInstance] authenticate];
    [[GIDSignIn sharedInstance] signIn];
}

-(void)setupGoogleLogin
{
    // *********** New google sign-in  *********** //
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.clientID = @"487854013147-unbo9frfk8tdc0kd5s41tftvdt7ratrk.apps.googleusercontent.com";
    signIn.scopes = @[ @"https://www.googleapis.com/auth/plus.login" ];
    signIn.delegate = self;
    signIn.uiDelegate = self;
}

#pragma mark - GSignIn Delegates

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
//    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    // ...
    
    RegisterViewController *vc = [RegisterViewController instantiateViewControllerWithIdentifier:@"RegisterViewController" fromStoryboard:@"Main"];
    // Pass the selected object to the new view controller.
    vc.name = fullName;
    vc.email = email;
    if (user.profile.hasImage) {
        vc.imageUrl = [user.profile imageURLWithDimension:60];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


@end
