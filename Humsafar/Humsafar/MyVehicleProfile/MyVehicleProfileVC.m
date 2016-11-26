//
//  MyVehicleProfileVC.m
//  Humsafar
//
//  Created by Rahul on 11/25/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "MyVehicleProfileVC.h"
#import "ActionSheetStringPicker.h"
#import "UITextField+Validation.h"
#import "UIImageView+AFNetworking.h"

#define kLicenseImagePickerTag 1234
#define kRCImagePickerTag 4321

@interface MyVehicleProfileVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *strLicenseUrl;
    NSString *strRCUrl;
    
    UIImage *licenseImage;
    UIImage *rcImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgView_qrCode;
@property (weak, nonatomic) IBOutlet UITextField *txt_vehicleNo;
@property (weak, nonatomic) IBOutlet UITextField *txt_vehicleType;
@property (weak, nonatomic) IBOutlet UIButton *btn_vehicleType;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_license;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_rc;
@property (weak, nonatomic) IBOutlet UIButton *btn_uploadLicense;
@property (weak, nonatomic) IBOutlet UIButton *btn_uploadRC;
@property (weak, nonatomic) IBOutlet UIButton *btn_upload;

@end

@implementation MyVehicleProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchDataListFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-(void)fetchDataListFromServer {
    
    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetVehicleDigitalIdentity withParameter:@{@"userMobile" : [UIViewController retrieveDataFromUserDefault:@"mobile"]} onCompletion:^(eResponseType responseType, id response) {
        
        [self hideProgressHudAfterDelay:.1];
        
        if (responseType == eResponseTypeSuccessJSON) {
            
            if ([response[kKEY_ResponseObject][@"errorCode"] integerValue] == 0){
                
                self.txt_vehicleNo.text = response[kKEY_ResponseObject][@"vehicleNo"];
                self.txt_vehicleType.text = response[kKEY_ResponseObject][@"vehicleType"];
                
                [self.imgView_license setImageWithURL:[NSURL URLWithString:response[kKEY_ResponseObject][@"licenseURL"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                [self.imgView_rc setImageWithURL:[NSURL URLWithString:response[kKEY_ResponseObject][@"rcURL"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                
                self.txt_vehicleNo.userInteractionEnabled = NO;
                self.txt_vehicleType.userInteractionEnabled = NO;
                self.btn_vehicleType.userInteractionEnabled = NO;
                self.btn_uploadLicense.hidden = YES;
                self.btn_uploadRC.hidden = YES;
                self.btn_upload.hidden = YES;
            }
            
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
        
    }];
}


#pragma mark - UITexyFiled  Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Btn Actions

- (IBAction)backBtnAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)uploadLicenseBtnAction:(UIButton *)sender {

    UIImagePickerController *imagePicker= [[UIImagePickerController alloc]init];
    imagePicker.view.tag = kLicenseImagePickerTag;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    [imagePicker setNavigationBarHidden:YES];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)uploadRCBtnAction:(UIButton *)sender {

    UIImagePickerController *imagePicker= [[UIImagePickerController alloc]init];
    imagePicker.view.tag = kRCImagePickerTag;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    [imagePicker setNavigationBarHidden:YES];
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)uploadBtnAction:(UIButton *)sender {
    
    if (_txt_vehicleNo.isEmptyField || _txt_vehicleType.isEmptyField || strLicenseUrl.length == 0 || strRCUrl.length == 0) {
        [self showAlert:@"All input fields are mandatory!"];
        
        return;
    }
    
    NSDictionary *paramsDict = @{@"userId":[UIViewController retrieveDataFromUserDefault:@"userId"],
                                 @"userMobile": [UIViewController retrieveDataFromUserDefault:@"mobile"],
                                 @"vehicleNo": _txt_vehicleNo.text,
                                 @"vehicleType": _txt_vehicleType.text,
                                 @"licenseURL": strLicenseUrl,
                                 @"rcURL": strRCUrl
                                 };
    
    [self showProgressHudWithMessage:@"uploading profile"];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:AddVehicleDigitalIdentity withParameter:paramsDict onCompletion:^(eResponseType responseType, id response) {
        
        [self hideProgressHudAfterDelay:0.1];
        
        if (responseType == eResponseTypeSuccessJSON)
        {
            [self showAlert:@"Uploaded successfully!"];
            
            self.txt_vehicleNo.userInteractionEnabled = NO;
            self.txt_vehicleType.userInteractionEnabled = NO;
            self.btn_vehicleType.userInteractionEnabled = NO;
            self.btn_uploadLicense.hidden = YES;
            self.btn_uploadRC.hidden = YES;
            self.btn_upload.hidden = YES;
        }
        else {
            if (responseType != eResponseTypeNoInternet)
            {
                [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
            }
        }
    }];
}

- (IBAction)showVehiclePicker:(id)sender {
    
    [self.view endEditing:YES];
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:@[@"2 Wheeler",@"4 Wheeler"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
        self.txt_vehicleType.text = selectedValue;
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

#pragma mark -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
       
        if (picker.view.tag == kRCImagePickerTag) {
            rcImage = image;
            self.imgView_rc.image = image;
            [self api_uploadRCImage];
        }else{
            licenseImage = image;
            [self api_uploadLicenseImage];
            self.imgView_license.image = image;
        }
    }];
}

#pragma mark - 

- (void)api_uploadLicenseImage {
    
    [self showProgressHudWithMessage:@"uploading image"];
    
    [[FFWebServiceHelper sharedManager] uploadImageWithUrl:UploadImage withParameters:@{@"file":licenseImage} onCompletion:^(eResponseType responseType, id response) {
        
        [self hideProgressHudAfterDelay:0.1];
        
        if (responseType == eResponseTypeSuccessJSON) {
            strLicenseUrl = response;
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
    }];
}

- (void)api_uploadRCImage {
    
    [self showProgressHudWithMessage:@"uploading image"];
    
    [[FFWebServiceHelper sharedManager] uploadImageWithUrl:UploadImage withParameters:@{@"file":rcImage} onCompletion:^(eResponseType responseType, id response) {
        
        [self hideProgressHudAfterDelay:0.1];
        
        if (responseType == eResponseTypeSuccessJSON) {
            strRCUrl = response;
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
        
    }];
}



@end
