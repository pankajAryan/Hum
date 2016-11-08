//
//  AddTrafficAlertVC.m
//  Humsafar
//
//  Created by Rahul on 11/9/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "AddTrafficAlertVC.h"
#import "ActionSheetStringPicker.h"
#import "UIViewController+Utility.h"
#import "UITextField+Validation.h"

@interface AddTrafficAlertVC ()
{
    NSString *selectedCategory;
    NSDictionary *selectedDistrictInfo;
}

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtMsg;
@property (weak, nonatomic) IBOutlet UITextField *txtDistrict;
@property (weak, nonatomic) IBOutlet UITextField *txtCategory;

@end

@implementation AddTrafficAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -

- (IBAction)showDistrictPicker:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableArray *districtArray = [UIViewController retrieveDataFromUserDefault:@"districts"];
    NSMutableArray *districtTitleArray = [NSMutableArray new];
    
    for (int i =0; i < districtArray.count; i++) {
        
        NSDictionary *dict = [districtArray objectAtIndex:i];
        [districtTitleArray addObject:[dict objectForKey:@"districtName"]];
    }
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:[districtTitleArray copy] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        if (selectedValueIndex < districtArray.count ) {
            
            selectedDistrictInfo = [districtArray objectAtIndex:selectedValueIndex];
            _txtDistrict.text = selectedValue;
        }
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

- (IBAction)showCategoryPicker:(id)sender {
    
    [self.view endEditing:YES];
    
    NSArray *categoryArray = @[@"Jams",@"Diversions",@"VIP Movements",@"Suggestions"];

    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:categoryArray initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        if (selectedValueIndex < categoryArray.count ) {
            
            selectedCategory = [categoryArray objectAtIndex:selectedValueIndex];
            _txtCategory.text = selectedValue;
        }
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

#pragma mark - btn action

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)assignBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];

    if (_txtTitle.isEmptyField || _txtMsg.isEmptyField || _txtCategory.isEmptyField || _txtDistrict.isEmptyField) {
        [self showAlert:@"All input fields are mandatory!"];
    }else {
        
#warning HardCoded State ID
        
        NSDictionary *paramsDict = @{@"stateId": @"29", @"title": _txtTitle.text, @"message": _txtMsg.text, @"category" : selectedCategory, @"districtId" : selectedDistrictInfo[@"districtId"], @"postedBy" : [UIViewController retrieveDataFromUserDefault:@"userId"]};
        
        [self showProgressHudWithMessage:@"Assigning.."];
        
        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:AddAlertForCategory withParameter:paramsDict onCompletion:^(eResponseType responseType, id response) {
            
            [self hideProgressHudAfterDelay:0.1];
            
            //2016-11-09 02:03:22.364 Humsafar[73162:1803217] {"responseObject":"19","errorCode":0,"errorMessage":"Success"}

            if (responseType == eResponseTypeSuccessJSON)
            {
                [self showAlert:@"Success"];
            }
            else {
                [self showAlert:@"fail"];
                if (responseType != eResponseTypeNoInternet)
                {
                }
            }
            
            [self cancelBtnAction:nil];
        }];
    }
}

@end
