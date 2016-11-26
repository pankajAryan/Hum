//
//  RoadSafetyEducationContainerVC.m
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "RoadSafetyEducationContainerVC.h"
#import "RoadSafetyEducationVC.h"

@interface RoadSafetyEducationContainerVC ()<GUITabPagerDataSource, GUITabPagerDelegate>

@property (nonatomic) NSArray *arrayOfVC;

@end

@implementation RoadSafetyEducationContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"LeftMenuScenes" bundle:nil];
    
    RoadSafetyEducationVC *vcVideos = [homeStory instantiateViewControllerWithIdentifier:@"RoadSafetyEducationVC"];
    vcVideos.roadSafetyEducationVCType = RoadSafetyEducationVCTypeVideos;
    
    RoadSafetyEducationVC *vcPdfs = [homeStory instantiateViewControllerWithIdentifier:@"RoadSafetyEducationVC"];
    vcPdfs.roadSafetyEducationVCType = RoadSafetyEducationVCTypePDFs;
    
    self.arrayOfVC = [NSArray arrayWithObjects:vcVideos,vcPdfs,nil];
    
    [self setDataSource:self];
    [self setDelegate:self];
    [self reloadData];
    [self selectTabbarIndex:0];
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
    
    switch (index) {
        case 0:
            return @"Videos";
            break;
        case 1:
            return @"PDFs";
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
    return [UIColor yellowColor];
}

- (UIColor *)tabBackgroundColor {
    
    return [UIColor blackColor];
    // Default: [UIColor colorWithWhite:0.95f alpha:1.0f];
    //    return [UIColor colorWithRed:249 / 255.0f green:224 / 255.0f blue:49 / 255.0f alpha:1];
}

- (UIFont *)titleFont {
    // Default: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
    return [UIFont fontWithName:@"HelveticaNeue-Regular" size:12.0f];
}

- (UIColor *)titleColor {
    // Default: [UIColor blackColor];
    return [UIColor whiteColor];//[UIColor colorWithRed:1.0f green:0.8f blue:0.0f alpha:1.0f];
}

#pragma mark - Tab Pager Delegate

- (void)tabPager:(GUITabPagerViewController *)tabPager willTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Will transition from tab %ld to %ld", (long)[self selectedIndex], (long)index);
}

- (void)tabPager:(GUITabPagerViewController *)tabPager didTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Did transition to tab %ld", (long)index);
}

@end
