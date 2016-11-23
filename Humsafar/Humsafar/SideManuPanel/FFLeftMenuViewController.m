//
//  FFLeftMenuViewController.m
//  FabFurnish
//
//  Created by Amit Kumar on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "FFLeftMenuViewController.h"

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "ProfileViewController2.h"
#import "HighwayServicesHomeVC.h"
#import "RoadSafetyEducationHomeVC.h"
#import "EmergencyContactsVC.h"
#import "GetAmbulanceViewController.h"
#import "AboutViewController.h"

#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"
#import "UIImageView+AFNetworking.h"
#import "MyFeedsVC.h"
#import "MyIncentiveVC.h"

static NSString *stringLeftMenuCellIdentifier  = @"LeftMenuCell";

@interface FFLeftMenuViewController ()

@end

@implementation FFLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imgVw_userImg.layer.cornerRadius = 28;
    self.imgVw_userImg.layer.masksToBounds = YES;
    self.imgVw_userImg.layer.borderColor = [UIColor orangeColor].CGColor;
    self.imgVw_userImg.layer.borderWidth = 3;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.lbl_name.text = [UIViewController retrieveDataFromUserDefault:@"name"];
    [self.imgVw_userImg setImageWithURL:[NSURL URLWithString:[UIViewController retrieveDataFromUserDefault:@"userImageUrl"]] placeholderImage:nil];
}

#pragma mark- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeViewController *homeController = (HomeViewController*)self.sideMenuViewController.contentViewController;

    switch (indexPath.row)
    {
        case 0: {
            
            if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
                
                ProfileViewController2 *vc = (ProfileViewController2 *)[UIViewController instantiateViewControllerWithIdentifier:@"ProfileViewController2" fromStoryboard:@"LeftMenuScenes"];
                [homeController.navigationController pushViewController:vc animated:YES];
            }else{ // G+ login
                
                ProfileViewController *vc = (ProfileViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"ProfileViewController" fromStoryboard:@"LeftMenuScenes"];
                [homeController.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1: {
            EmergencyContactsVC *vc = (EmergencyContactsVC *)[UIViewController instantiateViewControllerWithIdentifier:@"EmergencyContactsVC" fromStoryboard:@"LeftMenuScenes"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;

        case 2:
            
            if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
                
                MyFeedsVC *vc = (MyFeedsVC *)[UIViewController instantiateViewControllerWithIdentifier:@"MyFeedsVC" fromStoryboard:@"LeftMenuScenes"];
                [homeController.navigationController pushViewController:vc animated:YES];
            }else{ // G+ login
                MyIncentiveVC *vc = (MyIncentiveVC *)[UIViewController instantiateViewControllerWithIdentifier:@"MyIncentiveVC" fromStoryboard:@"LeftMenuScenes"];
                [homeController.navigationController pushViewController:vc animated:YES];
            }
            break;
            
        case 3:
            
            if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
//                return @"SCAN QR CODE";
            }else{ // G+ login
//                return @"MY VEHICLE PROFILE";
            }
            
            break;

        case 4: {
            RoadSafetyEducationHomeVC *vc = (RoadSafetyEducationHomeVC *)[UIViewController instantiateViewControllerWithIdentifier:@"RoadSafetyEducationHomeVC" fromStoryboard:@"LeftMenuScenes"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 5: {
            GetAmbulanceViewController *vc = [[GetAmbulanceViewController alloc] initWithNibName:@"GetAmbulanceViewController" bundle:nil];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;

        case 6: {
            HighwayServicesHomeVC *vc = (HighwayServicesHomeVC *)[UIViewController instantiateViewControllerWithIdentifier:@"HighwayServicesHomeVC" fromStoryboard:@"LeftMenuScenes"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
        
        case 7:
            //return [UIImage imageNamed:@"speed_analysis"];
            break;
            
        case 8:
            //return [UIImage imageNamed:@"faq"];
            break;
            
        case 9: {
            AboutViewController *vc = [AboutViewController new];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 10:
            [App_Delegate logout];
            break;
            
        default:
            break;
    }

    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stringLeftMenuCellIdentifier];
    
    UIImageView *icon = (UIImageView*)[cell viewWithTag:21];
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:22];

    icon.image = [self imageIconForMenuItemAtIndex:indexPath.row];
    titleLabel.text = [self titleForMenuItemAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark- Private Methods

- (UIImage*)imageIconForMenuItemAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            return [UIImage imageNamed:@"profile"];
            break;
            
        case 1:
            return [UIImage imageNamed:@"emerg_call"];
            break;
            
        case 2:
            return [UIImage imageNamed:@"signout"];
            break;

        case 3:
            return [UIImage imageNamed:@"signout"];
            break;

        case 4:
            return [UIImage imageNamed:@"road_safety"];
            break;
          
        case 5:
            return [UIImage imageNamed:@"ambulance"];
            break;
            
        case 6:
            return [UIImage imageNamed:@"highway"];
            break;
            
        case 7:
            return [UIImage imageNamed:@"speed_analysis"];
            break;
            
        case 8:
            return [UIImage imageNamed:@"faq"];
            break;
            
        case 9:
            return [UIImage imageNamed:@"about"];
            break;
         
        case 10:
            return [UIImage imageNamed:@"signout"];
            break;
            
        default: return nil;
            
            break;
    }
}

- (NSString*)titleForMenuItemAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
            return @"MY PROFILE";
            break;
            
        case 1:
            return @"EMERGENCY CONTACT";
            break;
            
        case 2:
            
            if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
                return @"MY FEED";
            }else{ // G+ login
                return @"MY INCENTIVES";
            }
            break;

        case 3:
            
            if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {// Normal Login
                return @"SCAN QR CODE";
            }else{ // G+ login
                return @"MY VEHICLE PROFILE";
            }

            break;

        case 4:
            return @"ROAD SAFETY EDUCATION";
            break;
            
        case 5:
            return @"GET AMBULANCE";
            break;
            
        case 6:
            return @"HIGHWAY SERVICES";
            break;
            
        case 7:
            return @"SPEED ANALYTICS";
            break;
            
        case 8:
            return @"FAQ'S";
            break;
   
        case 9:
            return @"ABOUT";
            break;
            
        case 10:
            return @"LOGOUT";
            break;
            
        default:
            return nil;
            
            break;
    }
}

/*

-(void) openCatalogueControllerWithData:(NSString*)dataModelURL{
    @try {
        HomeViewController *homeController = (HomeViewController*)[((UINavigationController*)self.sideMenuViewController.contentViewController) topViewController];
        [homeController pushToParticulerClass:@"catalog" withurl:dataModelURL header:nil];
    }
    @catch (NSException *exception) {
        
    }
}

*/




@end
