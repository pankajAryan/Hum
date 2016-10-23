//
//  CallPagerViewController.m
//  Humsafar
//
//  Created by B0081006 on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "CallPagerViewController.h"
#import "CallListVC.h"

@interface CallPagerViewController ()<GUITabPagerDataSource, GUITabPagerDelegate>

@property (nonatomic) NSArray *arrayOfVC;

@end

@implementation CallPagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    
    CallListVC *vcMedical = [homeStory instantiateViewControllerWithIdentifier:@"CallListVC"];
    vcMedical.callListVCType = CallListVCTypeMedical;

    CallListVC *vcPolice = [homeStory instantiateViewControllerWithIdentifier:@"CallListVC"];
    vcMedical.callListVCType = CallListVCTypePolice;

    CallListVC *vcTransport = [homeStory instantiateViewControllerWithIdentifier:@"CallListVC"];
    vcMedical.callListVCType = CallListVCTypeTransport;

    
    self.arrayOfVC = [NSArray arrayWithObjects:vcMedical,vcPolice,vcTransport,nil];
    
    [self setDataSource:self];
    [self setDelegate:self];
    [self reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Tab Pager Data Source

- (NSInteger)numberOfViewControllers {
    return 3;
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    
    return self.arrayOfVC[index];
}

- (NSString *)titleForTabAtIndex:(NSInteger)index {
    //return [NSString stringWithFormat:@"Tab #%ld", (long) index + 1];
    
    switch (index) {
        case 0:
            return @"Medical";
            break;
        case 1:
            return @"Police";
            break;
        case 2:
            return @"Transport";
            break;
            
        default: return @"";
            break;
    }
}

- (CGFloat)tabHeight {
    // Default: 44.0f
    return 50.0f;
}

- (UIColor *)tabColor {
    // Default: [UIColor orangeColor];
    return [UIColor colorWithRed:254 / 255.0f
                           green:215 / 255.0f
                            blue:49 / 255.0f alpha:1];
}

- (UIColor *)tabBackgroundColor {
    // Default: [UIColor colorWithWhite:0.95f alpha:1.0f];
    return [UIColor colorWithRed:22 / 255.0f
                           green:22 / 255.0f
                            blue:22 / 255.0f alpha:1];
}

- (UIFont *)titleFont {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
}

- (UIColor *)titleColor {
    return [UIColor whiteColor];
}

#pragma mark - Tab Pager Delegate

- (void)tabPager:(GUITabPagerViewController *)tabPager willTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Will transition from tab %ld to %ld", (long)[self selectedIndex], (long)index);
}

- (void)tabPager:(GUITabPagerViewController *)tabPager didTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Did transition to tab %ld", (long)index);
}

@end
