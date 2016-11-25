//
//  MyIncentiveVC.m
//  Humsafar
//
//  Created by Rahul on 11/24/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "MyIncentiveVC.h"

@interface MyIncentiveVC ()

@end

@implementation MyIncentiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchDataListFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Btn Action

- (IBAction)backBtnACTION:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

-(void)fetchDataListFromServer {
    
    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetIncentiveWalletBalanceForUser withParameter:@{@"userMobile" : [UIViewController retrieveDataFromUserDefault:@"mobile"]} onCompletion:^(eResponseType responseType, id response) {
        
        [self hideProgressHudAfterDelay:.1];
        
//        {
//            errorCode = 1;
//            errorMessage = "Error fetchh wallet balance. Please try after sometime!";
//            responseObject = "<null>";
//        }
        
        if (responseType == eResponseTypeSuccessJSON) {
//            self.arrayList = [response objectForKey:kKEY_ResponseObject];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
        
//        [self.tblView reloadData];
    }];
}

@end
