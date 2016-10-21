//
//  DEMOViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "FFLeftMenuViewController.h"
#import "HomeViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    //self.contentViewShadowColor = [UIColor ffDarkGrayColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewController = (HomeViewController *)[HomeViewController instantiateViewControllerWithIdentifier:@"HomeViewController" fromStoryboard:@"Home"];
    
    FFLeftMenuViewController *leftMenuController = (FFLeftMenuViewController *)[FFLeftMenuViewController instantiateViewControllerWithIdentifier:@"FFLeftMenuViewController" fromStoryboard:@"Home"];
    leftMenuController.menuTitle = @"Home";
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:leftMenuController];
//    [navigationController setNavigationBarHidden:YES];
    self.leftMenuViewController = leftMenuController;
    self.rightMenuViewController = nil;
//    self.backgroundImage = [UIImage imageNamed:@"Stars"];
    self.delegate = self;
}

#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

@end
