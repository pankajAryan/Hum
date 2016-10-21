//
//  RegisterViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "RegisterViewController.h"
#import "ActionSheetStringPicker.h"
#import "UITextField+Validation.h"
#import "UIViewController+Utility.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtFieldName;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldState;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldDist;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetStates withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            arrayStatesData = [response objectForKey:kKEY_ResponseObject];
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
- (IBAction)showStatePicker:(id)sender {
   
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetDistricts withParameter:@{@"stateId":@"29"} onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            arrayDistrictsData = [response objectForKey:kKEY_ResponseObject];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
            // [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
        }
    }];
    
    /*
    [_txtFieldName resignFirstResponder];
    [_txtFieldMobile resignFirstResponder];
    [_txtFieldEmail resignFirstResponder];
    [_txtFieldState resignFirstResponder];
    [_txtFieldDist resignFirstResponder];
    
    NSMutableArray *stateTitles = [NSMutableArray new];
    
    for (int i =0; i < arrayStatesData.count; i++) {
        
        NSDictionary *dict = [arrayStatesData objectAtIndex:i];
        [stateTitles addObject:[dict objectForKey:@"productName"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:[stateTitles copy] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        //selectedIndex = selectedValueIndex;
        
        _txtFieldState.text = selectedValue;
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
    
    */
}

- (IBAction)showDistrictPicker:(id)sender {
    
    [_txtFieldName resignFirstResponder];
    [_txtFieldMobile resignFirstResponder];
    [_txtFieldEmail resignFirstResponder];
    [_txtFieldState resignFirstResponder];
    [_txtFieldDist resignFirstResponder];
    
    NSMutableArray *DistTitles = [NSMutableArray new];
    
    for (int i =0; i < arrayDistrictsData.count; i++) {
        
        NSDictionary *dict = [arrayDistrictsData objectAtIndex:i];
        [DistTitles addObject:[dict objectForKey:@"productName"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:[DistTitles copy] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        //selectedIndex = selectedValueIndex;
        
        _txtFieldState.text = selectedValue;
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

- (IBAction)registerButtonDidTap:(id)sender {
    
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
        // Register API
        //        name
        //        mobile
        //        email
        //        favoriteProduct
        //        password
        
        if ([UIViewController isNetworkAvailable])
        {
            [self showProgressHudWithMessage:@"Registering user"];
        }
        else {
            [self showAlert:@"No internet available!"];
        }
    }
}

@end


