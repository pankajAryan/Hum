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
}
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedCategory = @"";
    self.manager = [CLLocationManager updateManagerWithAccuracy:100.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];

    if ([self.navType isEqualToString:@"emergency"]) {
        self.imgVw_reportImg.image = self.image;

    }else if ([self.navType isEqualToString:@"report"]) {
        self.imgVw_reportImg.image = self.image;

    }
    
    //[self api_uploadImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchLocation];
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
    
    if ([self.navType isEqualToString:@"emergency"]) {
        //hit service for emergency
    }else if ([self.navType isEqualToString:@"report"]) {
        //hit service for report
    }
    
//    [[FFWebServiceHelper sharedManager] uploadImageWithUrl:UploadImage withParameters:@{@"file":self.image} onCompletion:^(eResponseType responseType, id response) {
//        if (responseType == eResponseTypeSuccessJSON) {
//            
//        }else{
//            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
//        }
//    }];
}

-(void)api_uploadOtherInfo {
    
    if ([self.navType isEqualToString:@"emergency"]) {
        
    }else if ([self.navType isEqualToString:@"report"]) {
        
    }
    
    if (selectedCategory.length == 0) {
        [self showAlert:@"Please select issue category"];
        return;
    }
    
    if (lat == nil || lon == nil) {
        lat = @"";
        lon = @"";
    }
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:ReportIssue withParameter:@{@"category" : selectedCategory, @"lat" : lat, @"lon" : lon, @"postedBy" : @"Pankaj Yadav", @"description" : self.txtVw_desc.text, @"uploadedImageURL" : @"", @"stateId" : @"29"} onCompletion:^(eResponseType responseType, id response) {
        if (responseType == eResponseTypeSuccessJSON) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
    }];
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
    NSArray *arrayStates = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",nil];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:arrayStates initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        [self.button_selectIssueType setTitle:selectedValue forState:UIControlStateNormal];
        selectedCategory = selectedValue;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

- (IBAction)action_goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)action_done:(id)sender {
    //API Call
    [self api_uploadOtherInfo];
}

@end
