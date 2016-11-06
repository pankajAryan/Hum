//
//  ReportViewController.m
//  Humsafar
//
//  Created by B0081006 on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "ReportViewController.h"
#import "ActionSheetStringPicker.h"
#import "FFWebServiceHelper.h"

@interface ReportViewController ()
{
    NSString *lat;
    NSString *lon;
    NSString *selectedCategory;
    NSString *uploadedImageURL;
    NSArray *arrayIssueTypes;
    NSDictionary *selectedDistrictInfo;
}
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedCategory = @"";
    arrayIssueTypes = [NSArray arrayWithObjects:@"ROAD CONDITION",@"STREET LIGHT",@"TRAFFIC LIGHT",@"TRAFFIC PERSONNEL",@"OTHER", nil];
    self.manager = [CLLocationManager updateManagerWithAccuracy:100.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    
    if ([self.navType isEqualToString:@"emergency"]) {
        self.imgVw_reportImg.image = self.image;
        self.button_selectIssueType.hidden = YES;
        self.label_title.text = @"REPORT EMERGENCY";
        self.imgVw_dropdown.hidden = YES;
    }else if ([self.navType isEqualToString:@"report"]) {
        self.imgVw_reportImg.image = self.image;
        self.button_selectIssueType.hidden = NO;
        self.label_title.text = @"REPORT ISSUE";
        self.imgVw_dropdown.hidden = NO;
    }
    
    selectedDistrictInfo = [UIViewController retrieveDataFromUserDefault:@"selectedDistrictDict"];

    [self api_uploadImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchLocation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


-(void)fetchLocation {
    
    if ([CLLocationManager isLocationUpdatesAvailable]) {
        
        [self.manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            
            *stopUpdating = YES;
            
            if (location)
            {
                lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];                
            }
            else
                [self showAlert:@"Could not determine your location. Please check location settings."];
        }];
    }
    else {
        [self showAlert:@"Please enable location services from settings."];
    }
    
}

#pragma mark - API Calls

- (void)api_uploadImage {
    
    [self showProgressHudWithMessage:@"uploading image"];

    [[FFWebServiceHelper sharedManager] uploadImageWithUrl:UploadImage withParameters:@{@"file":self.image} onCompletion:^(eResponseType responseType, id response) {
        
        [self hideProgressHudAfterDelay:0.1];
        
        if (responseType == eResponseTypeSuccessJSON) {
            uploadedImageURL = response;
            //[self api_uploadOtherInfo];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
        
    }];
}

-(void)api_uploadOtherInfo {
    
    NSString *stateId = selectedDistrictInfo[@"stateId"];
    NSString *userId = [UIViewController retrieveDataFromUserDefault:@"userId"];
    
    if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {
        stateId = @"29";
    }
    
    if (stateId == nil || userId == nil)
        return;
    
    if (uploadedImageURL == nil) {
        [self showAlert:@"Image url not found."];
        return;
    }
    
    
    if ([self.navType isEqualToString:@"emergency"])
    {
        selectedCategory = @"";
        if (lat == nil || lon == nil) {
            lat = @"";
            lon = @"";
        }
        
        [self showProgressHudWithMessage:@"submitting.."];

        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:ReportEmergency withParameter:@{@"lat" : lat, @"lon" : lon, @"postedBy" : userId, @"description" : self.txtVw_desc.text, @"uploadedImageURL" : uploadedImageURL, @"stateId" : stateId} onCompletion:^(eResponseType responseType, id response) {
            
            [self hideProgressHudAfterDelay:0.1];
            
            @try {
                if (responseType == eResponseTypeSuccessJSON) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                }
            } @catch (NSException *exception) {
                
            }
        }];
        
    }
    else if ([self.navType isEqualToString:@"report"])
    {
        if (selectedCategory.length == 0) {
            [self showAlert:@"Please select issue category and try again."];
            return;
        }
        
        if (lat == nil || lon == nil) {
            [self showAlert:@"Please ensure your GPS is enable. Go to Settings app to enable GPS."];
            return;
        }
        
        [self showProgressHudWithMessage:@"submitting.."];

        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:ReportIssue withParameter:@{@"category" : selectedCategory, @"lat" : lat, @"lon" : lon, @"postedBy" : userId, @"description" : self.txtVw_desc.text, @"uploadedImageURL" : uploadedImageURL, @"stateId" : stateId} onCompletion:^(eResponseType responseType, id response) {
            
            [self hideProgressHudAfterDelay:0.1];

            @try {
                if (responseType == eResponseTypeSuccessJSON) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                }
            } @catch (NSException *exception) {
                
            }
            
        }];
        
    }
}


#pragma mark - UITextFieldDelegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.scrollVw_report setContentOffset:CGPointMake(self.scrollVw_report.frame.origin.x, 0) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.scrollVw_report setContentOffset:CGPointMake(self.scrollVw_report.frame.origin.x, textField.frame.origin.y - 40) animated:YES];
    return YES;
}

#pragma mark - UIScrollViewDelegates

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([self.txtVw_desc isFirstResponder])
//        [self.txtVw_desc resignFirstResponder];
}

#pragma mark - IBActions

- (IBAction)action_selectIssueType:(id)sender {
    if (arrayIssueTypes.count != 0) {
        [ActionSheetStringPicker showPickerWithTitle:nil rows:arrayIssueTypes initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
            [self.button_selectIssueType setTitle:selectedValue forState:UIControlStateNormal];
            selectedCategory = selectedValue;
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            NSLog(@"Block Picker Canceled");
        } origin:sender];
    }else{
        [self showAlert:@"There are no issues to select"];
    }
}

- (IBAction)action_goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action_done:(id)sender {
    //API Call
    [self api_uploadOtherInfo];
}

@end
