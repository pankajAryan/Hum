//
//  HomePagerViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 18/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomePagerViewController.h"

@interface HomePagerViewController () <GUITabPagerDataSource, GUITabPagerDelegate>

@end

@implementation HomePagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDataSource:self];
    [self setDelegate:self];
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
    [self reloadData];
}

#pragma mark - Tab Pager Data Source

- (NSInteger)numberOfViewControllers {
    return 4;
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    UIViewController *vc = [UIViewController new];
    [[vc view] setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255) / 255.0f
                                                  green:arc4random_uniform(255) / 255.0f
                                                   blue:arc4random_uniform(255) / 255.0f alpha:1]];
    return vc;
}

// Implement either viewForTabAtIndex: or titleForTabAtIndex:
//- (UIView *)viewForTabAtIndex:(NSInteger)index {
//  return <#UIView#>;
//}

- (NSString *)titleForTabAtIndex:(NSInteger)index {
    //return [NSString stringWithFormat:@"Tab #%ld", (long) index + 1];
    
    switch (index) {
        case 0:
            return @"Jams";
            break;
        case 1:
            return @"Diversions";
            break;
        case 2:
            return @"VIP Movements";
            break;
        case 3:
            return @"Suggestions";
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
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
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
