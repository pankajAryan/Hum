//
//  HomePagerViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 18/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomePagerViewController.h"
#import "HomeListVC.h"
#import "HomeListVC2.h"
#import "CallListVC.h"

@interface HomePagerViewController () <GUITabPagerDataSource, GUITabPagerDelegate>

@property (nonatomic) NSArray *arrayOfVC;

@end

@implementation HomePagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#warning hardcoded true
    if (true) {// Normal Login
        
        UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        HomeListVC2 *vcEmergencie = [homeStory instantiateViewControllerWithIdentifier:@"HomeListVC2"];
        vcEmergencie.homeListVC2Type = HomeListVC2TypeEmergencie;
        
        HomeListVC2 *vcIssue = [homeStory instantiateViewControllerWithIdentifier:@"HomeListVC2"];
        vcIssue.homeListVC2Type = HomeListVC2TypeIssue;
        
        CallListVC *vcDirectory = [homeStory instantiateViewControllerWithIdentifier:@"CallListVC"];
        vcDirectory.callListVCType = CallListVCTypeOther;
        
        self.arrayOfVC = [NSArray arrayWithObjects:vcEmergencie,vcIssue,vcDirectory,nil];

    }else{ // G+ login
        
        UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        
        HomeListVC *vcJam = [homeStory instantiateViewControllerWithIdentifier:@"HomeListVC"];
        vcJam.homeListVCType = HomeListVCTypeJams;
        
        HomeListVC *vcDiversions = [homeStory instantiateViewControllerWithIdentifier:@"HomeListVC"];
        vcDiversions.homeListVCType = HomeListVCTypeDiversions;
        
        HomeListVC *vcVIPMovements = [homeStory instantiateViewControllerWithIdentifier:@"HomeListVC"];
        vcVIPMovements.homeListVCType = HomeListVCTypeVIPMovements;
        
        HomeListVC *vcSuggestions = [homeStory instantiateViewControllerWithIdentifier:@"HomeListVC"];
        vcSuggestions.homeListVCType = HomeListVCTypeSuggestions;
        
        self.arrayOfVC = [NSArray arrayWithObjects:vcJam,vcDiversions,vcVIPMovements,vcSuggestions,nil];
    }
    
    
    
    [self setDataSource:self];
    [self setDelegate:self];
    [self reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Tab Pager Data Source

- (NSInteger)numberOfViewControllers {
    return self.arrayOfVC.count;
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
   
    return self.arrayOfVC[index];
}

// Implement either viewForTabAtIndex: or titleForTabAtIndex:
//- (UIView *)viewForTabAtIndex:(NSInteger)index {
//  return <#UIView#>;
//}

- (NSString *)titleForTabAtIndex:(NSInteger)index {
    //return [NSString stringWithFormat:@"Tab #%ld", (long) index + 1];
    
    #warning hardcoded true
    if (true) {// Normal Login

        switch (index) {
            case 0:
                return @"Emergenie";
            case 1:
                return @"Issue";
            case 2:
                return @"Directory";
            default:
                return @"";
                break;
        }

    }else{// G+ login
        
        switch (index) {
            case 0:
                return @"Jams";
            case 1:
                return @"Diversions";
            case 2:
                return @"VIP Movements";
            case 3:
                return @"Suggestions";
            default: return @"";
                break;
        }
    }
}

- (CGFloat)tabHeight {
    // Default: 44.0f
    return 50.0f;
}

- (UIColor *)tabColor {
    // Default: [UIColor orangeColor];
    return [UIColor whiteColor];
}

- (UIColor *)tabBackgroundColor {
    // Default: [UIColor colorWithWhite:0.95f alpha:1.0f];
    return [UIColor colorWithRed:249 / 255.0f
                           green:224 / 255.0f
                            blue:49 / 255.0f alpha:1];
}

- (UIFont *)titleFont {
    // Default: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
}

- (UIColor *)titleColor {
    // Default: [UIColor blackColor];
    return [UIColor blackColor];//[UIColor colorWithRed:1.0f green:0.8f blue:0.0f alpha:1.0f];
}

#pragma mark - Tab Pager Delegate

- (void)tabPager:(GUITabPagerViewController *)tabPager willTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Will transition from tab %ld to %ld", (long)[self selectedIndex], (long)index);
}

- (void)tabPager:(GUITabPagerViewController *)tabPager didTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Did transition to tab %ld", (long)index);
}


@end
