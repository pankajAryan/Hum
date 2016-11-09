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

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn_menu;
@property (strong, nonatomic) NSString *navType;
@property (weak, nonatomic) IBOutlet UIButton *alertBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [_btn_menu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
        [self fetchDistrictListForStateId:@"29"];//Hardcode
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
        PlacesSearchVC *vc = (PlacesSearchVC *)[UIViewController instantiateViewControllerWithIdentifier:@"PlacesSearchVC" fromStoryboard:@"Home"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}


@end
