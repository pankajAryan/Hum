//
//  NSString+device.m
//  FabFurnish
//
//  Created by Avneesh.minocha on 05/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <sys/utsname.h>
#import "NSString+device.h"
#include <ifaddrs.h>
#include <arpa/inet.h>


@implementation NSString (device)



+ (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}


+(NSString *)devicename
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"iPhone Device%@",[self platformType:platform]);
    return [self platformType:platform];
}
+ (NSString *)platformType:(NSString *)platform
{
    if ([platform isEqualToString:@"iPhone3,1"])    return @"4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"5";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"5";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"5";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"5";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"6+";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (NSString*) deviceUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *newUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return newUUID;
}

- (NSString*)trimWhiteSpacesAndNewline {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
