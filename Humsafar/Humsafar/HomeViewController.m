//
//  HomeViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+RESideMenu.h"
#import "ReportViewController.h"
#import "AddTrafficAlertVC.h"
#import "PlacesSearchVC.h"
#import "MyIncentiveVC.h"

#import <GooglePlaces/GooglePlaces.h>

@interface HomeViewController ()<GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_menu;
@property (strong, nonatomic) NSString *navType;
@property (weak, nonatomic) IBOutlet UIButton *alertBtn;

@property (weak, nonatomic) IBOutlet UIView *incentiveView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_incentiveAmount;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [_btn_menu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
        [self fetchDistrictListForStateId:@"29"];//Hardcode
        self.incentiveView.hidden = YES;
    }else{
        [self.alertBtn setBackgroundImage:[UIImage imageNamed:@"route"] forState:UIControlStateNormal];
        self.incentiveView.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (! [[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
        [self fetchWalletBalanceForUserFromServer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)walletButtonAction:(id)sender {
    MyIncentiveVC *vc = (MyIncentiveVC *)[UIViewController instantiateViewControllerWithIdentifier:@"MyIncentiveVC" fromStoryboard:@"LeftMenuScenes"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
        if ([segue.identifier isEqualToString:@"CallViewControllerSegue"]) {
            NSArray *arrayDistricts = [UIViewController retrieveDataFromUserDefault:@"districts"];
            if (arrayDistricts == nil) {
                    [self fetchDistrictListForStateId:@"29"];//Hardcode
            }
        }
    }
}

#pragma mark -

-(void)fetchWalletBalanceForUserFromServer {
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetIncentiveWalletBalanceForUser withParameter:@{@"userMobile" : [UIViewController retrieveDataFromUserDefault:@"mobile"]} onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            self.lbl_incentiveAmount.text = [NSString stringWithFormat:@"%@",response[@"responseObject"]];
        }else{
            //[self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
    }];
}

- (void)fetchDistrictListForStateId:(NSString*)stateId {
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetDistricts withParameter:@{@"stateId" : stateId} onCompletion:^(eResponseType responseType, id response) {
        
        @try {
            if (responseType == eResponseTypeSuccessJSON) {
                NSArray *arrayDistricts = [response objectForKey:kKEY_ResponseObject];
                if (arrayDistricts != nil) {
                    [UIViewController saveDatatoUserDefault:arrayDistricts forKey:@"districts"];
                }
            }else{
                
            }
        } @catch (NSException *exception) {
            
        }
        
    }];
}





#pragma mark- ImagePickerControllerDelegate

-(IBAction)action_openCamera:(id)sender{
    if ([sender tag] == 1) {
        self.navType = @"emergency";
        UIImagePickerController *imagePicker= [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [imagePicker setNavigationBarHidden:YES];
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }else if ([sender tag] == 2){
        self.navType = @"report";
        UIImagePickerController *imagePicker= [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [imagePicker setNavigationBarHidden:YES];
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        ReportViewController *vcReport = [homeStory instantiateViewControllerWithIdentifier:@"ReportViewController"];
        vcReport.image = image;
        vcReport.navType = self.navType;
        [self.navigationController pushViewController:vcReport animated:NO];
    }];
}

- (IBAction)addAlertBtnAction:(UIButton *)sender {
    
    if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
    
        AddTrafficAlertVC *vc = (AddTrafficAlertVC *)[UIViewController instantiateViewControllerWithIdentifier:@"AddTrafficAlertVC" fromStoryboard:@"Home"];
        
        vc.providesPresentationContextTransitionStyle = YES;
        vc.definesPresentationContext = YES;
        [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        
    }else{ // G+ login
    
//        PlacesSearchVC *vc = (PlacesSearchVC *)[UIViewController instantiateViewControllerWithIdentifier:@"PlacesSearchVC" fromStoryboard:@"Other"];
//        [self.navigationController presentViewController:vc animated:YES completion:nil];
        
        [GMSPlacesClient provideAPIKey:@"AIzaSyBxRgQr0Rslm3I9fEqY9LE4cXJQQ-yZFN8"];
        GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
        acController.delegate = self;
        [self presentViewController:acController animated:YES completion:nil];

    }
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.

    
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    NSString *urlString;
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]])
    {
        urlString = [NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&zoom=14&directionsmode=driving",place.coordinate.latitude,place.coordinate.longitude];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f&q=%@",place.coordinate.latitude, place.coordinate.longitude,[place.name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", (long)[error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    NSLog(@"Autocomplete was cancelled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
