//
//  AppDelegate.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerForRemoteNotifications];

    [GMSServices provideAPIKey:@"AIzaSyAn04qD5eAnR2YV_h-J8xNoLz4rzBvN_ow"];

    NSString *userId = [UIViewController retrieveDataFromUserDefault:@"userId"];
    BOOL isLoggedIn = [[UIViewController retrieveDataFromUserDefault:@"isUserLoggedIn"] boolValue];

    if (isLoggedIn && (userId && userId.length)) {
        
        self.rootNavController = (UINavigationController*)self.window.rootViewController; // it'll return UINavigationController which is set as Initial view controller in storyboard.
        
        RootViewController *rootVC = [RootViewController instantiateViewControllerWithIdentifier:@"RootViewController" fromStoryboard:@"Main"];
        
        self.rootNavController.viewControllers = @[rootVC];
        
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)logout {
    
    [[GIDSignIn sharedInstance] signOut];
    [UIViewController saveDatatoUserDefault:@"" forKey:@"userId"];
    [UIViewController saveDatatoUserDefault:@"0" forKey:@"isUserLoggedIn"];

    UINavigationController *rootVC = [UINavigationController instantiateViewControllerWithIdentifier:@"rootNavController" fromStoryboard:@"Main"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.window.rootViewController = rootVC;
        [self.window makeKeyAndVisible];
    });
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -

- (void)registerForRemoteNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [deviceToken description];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (token != nil) {
        [UIViewController saveDatatoUserDefault:token forKey:@"DEVICE_TOKEN"];
    }
}

#pragma mark -

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
}

@end
