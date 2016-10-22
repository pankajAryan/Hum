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

#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"

static NSString *stringLeftMenuCellIdentifier  = @"LeftMenuCell";

@interface FFLeftMenuViewController ()

@end

@implementation FFLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeViewController *homeController = (HomeViewController*)self.sideMenuViewController.contentViewController;

    switch (indexPath.row)
    {
        case 0: {
            ProfileViewController *vc = (ProfileViewController *)[UIViewController instantiateViewControllerWithIdentifier:@"ProfileViewController" fromStoryboard:@"LeftMenuScenes"];
            [homeController.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:      ;
            
            break;
    }

    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark- TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
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
            return [UIImage imageNamed:@"road_safety"];
            break;
            
        case 6:
            return [UIImage imageNamed:@"about"];
            break;
            
        case 7:
            return [UIImage imageNamed:@"faq"];
            break;
            
        default: return [UIImage imageNamed:@"road_safety"];
            
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
            return @"ROAD SAFETY EDUCATION";
            break;
            
        case 3:
            return @"GET AMBULANCE";
            break;
            
        case 4:
            return @"HIGHWAY SERVICES";
            break;
            
        case 5:
            return @"SPEED ANALYTICS";
            break;
            
        case 6:
            return @"FAQ'S";
            break;
   
        case 7:
            return @"ABOUT";
            break;
            
        case 8:
            return @"LOGOUT";
            break;
            
        default:     return nil;
            
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
