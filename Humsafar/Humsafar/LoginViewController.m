//
//  LoginViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController () {
    
    NSString *lat;
    NSString *lon;
}
@property (nonatomic, strong) CLLocationManager *manager;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.manager = [CLLocationManager updateManagerWithAccuracy:100.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (lat == nil) {
        
        if ([CLLocationManager isLocationUpdatesAvailable]) {
            
            [self.manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
                
                *stopUpdating = YES;
                
                if (location)
                {
                    lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                    lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
                    
                    // Fetch latest data
                }
                else
                    [self showAlert:@"Could not determine your location. Please check location settings."];
            }];
        }
        else {
            [self showAlert:@"Please enable location services from settings."];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"seguePushRegisterPage"]) {
        // Get the new view controller using [segue destinationViewController].
        RegisterViewController *vc = segue.destinationViewController;
        // Pass the selected object to the new view controller.
        vc.name = @"Pankaj Yadav";
        vc.email = @"sinaarav@gmail.com";
    }
}

- (IBAction)loginButtonDidTap:(id)sender {
}




@end
