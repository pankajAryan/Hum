//
//  ProfileViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 22/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "ProfileViewController.h"
#import "ActionSheetStringPicker.h"
#import "UITextField+Validation.h"
#import "UIViewController+Utility.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()<UITextFieldDelegate>
{
    NSArray *arrayStatesData;
    NSArray *arrayDistrictsData;
    
    NSDictionary *selectedStateInfo;
    NSDictionary *selectedDistrictInfo;
}
@property (weak, nonatomic) IBOutlet UITextField *txtFieldName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldState;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldDist;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.layer.cornerRadius = 28;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.imageView.layer.borderWidth = 3;
    
    selectedStateInfo = [UIViewController retrieveDataFromUserDefault:@"selectedStateDict"];
    selectedDistrictInfo = [UIViewController retrieveDataFromUserDefault:@"selectedDistrictDict"];
    arrayDistrictsData = [UIViewController retrieveDataFromUserDefault:@"selectedStateDistrictArray"];


    self.txtFieldName.text = [UIViewController retrieveDataFromUserDefault:@"name"];
    self.txtFieldEmail.text = [UIViewController retrieveDataFromUserDefault:@"email"];
    self.txtFieldMobile.text = [UIViewController retrieveDataFromUserDefault:@"mobile"];
    
    self.txtFieldState.text = selectedStateInfo[@"stateName"];
    self.txtFieldDist.text = selectedDistrictInfo[@"districtName"];

    [self.imageView setImageWithURL:[NSURL URLWithString:[UIViewController retrieveDataFromUserDefault:@"userImageUrl"]] placeholderImage:nil];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetStates withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            arrayStatesData = [response objectForKey:kKEY_ResponseObject];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{   // return NO to not change text
    
    if (textField == _txtFieldMobile) {
        NSString *mobile = [NSString stringWithFormat:@"%@%@",textField.text, string];
        if (mobile.length > 10) {
            return NO;
        }else{
            NSCharacterSet *blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
            return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Button Actions

- (IBAction)backButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- Button Actions
- (IBAction)showStatePicker:(id)sender {
    
    [self.view endEditing:YES];
    NSMutableArray *stateTitles = [NSMutableArray new];
    
    for (int i =0; i < arrayStatesData.count; i++) {
        
        NSDictionary *dict = [arrayStatesData objectAtIndex:i];
        [stateTitles addObject:[dict objectForKey:@"stateName"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:[stateTitles copy] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        if (selectedValueIndex < arrayStatesData.count ) {
            
            selectedStateInfo = [arrayStatesData objectAtIndex:selectedValueIndex];
            _txtFieldState.text = selectedValue;
            _txtFieldDist.text = @"";
        }
        
        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetDistricts withParameter:@{@"stateId":selectedStateInfo[@"stateId"]} onCompletion:^(eResponseType responseType, id response) {
            
            if (responseType == eResponseTypeSuccessJSON) {
                arrayDistrictsData = [response objectForKey:kKEY_ResponseObject];
            }
            else{
                [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                // [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
            }
        }];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
    
}

- (IBAction)showDistrictPicker:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableArray *DistTitles = [NSMutableArray new];
    
    for (int i =0; i < arrayDistrictsData.count; i++) {
        
        NSDictionary *dict = [arrayDistrictsData objectAtIndex:i];
        [DistTitles addObject:[dict objectForKey:@"districtName"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:[DistTitles copy] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        if (selectedValueIndex < arrayDistrictsData.count ) {
            
            selectedDistrictInfo = [arrayDistrictsData objectAtIndex:selectedValueIndex];
            _txtFieldDist.text = selectedValue;
        }
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

- (IBAction)updateButtonDidTap:(id)sender {
    
    if (_txtFieldName.isEmptyField || _txtFieldMobile.isEmptyField || _txtFieldEmail.isEmptyField || _txtFieldState.isEmptyField || _txtFieldDist.isEmptyField) {
        [self showAlert:@"All input fields are mandatory!"];
    }
    else if (!_txtFieldMobile.isMobileNumberValid) {
        [self showAlert:@"Mobile must contain 10 characters!"];
    }
    else if (!_txtFieldEmail.isEmailValid) {
        [self showAlert:@"Invalid Email address!"];
    }
    else {
        
        NSDictionary *paramsDict = @{@"userName": _txtFieldName.text, @"emailId": _txtFieldEmail.text, @"profileImageURL": [UIViewController retrieveDataFromUserDefault:@"userImageUrl"], @"mobileNumber": _txtFieldMobile.text, @"stateId": selectedStateInfo[@"stateId"], @"defaultDistrictId": selectedDistrictInfo[@"districtId"], @"userId":[UIViewController retrieveDataFromUserDefault:@"userId"]};
        
        [self showProgressHudWithMessage:@"Updating profile"];
        
        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:UpdateUserProfile withParameter:paramsDict onCompletion:^(eResponseType responseType, id response) {
            
            [self hideProgressHudAfterDelay:0.1];
            
            if (responseType == eResponseTypeSuccessJSON)
            {
                [self showAlert:@"Profile updated successfully!"];
                
                [UIViewController saveDatatoUserDefault:[response objectForKey:@"responseObject"] forKey:@"userId"];
                [UIViewController saveDatatoUserDefault:_txtFieldName.text forKey:@"name"];
                [UIViewController saveDatatoUserDefault:_txtFieldEmail.text forKey:@"email"];
                [UIViewController saveDatatoUserDefault:_txtFieldMobile.text forKey:@"mobile"];
//                [UIViewController saveDatatoUserDefault:_imageUrl.absoluteString forKey:@"userImageUrl"];
                [UIViewController saveDatatoUserDefault:selectedStateInfo forKey:@"selectedStateDict"];
                [UIViewController saveDatatoUserDefault:selectedDistrictInfo forKey:@"selectedDistrictDict"];
                [UIViewController saveDatatoUserDefault:arrayDistrictsData forKey:@"selectedStateDistrictArray"];
            }
            else {
                if (responseType != eResponseTypeNoInternet)
                {
                    [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
                }
            }
        }];
    }
}

@end
