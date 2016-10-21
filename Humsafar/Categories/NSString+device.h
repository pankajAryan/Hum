//
//  NSString+device.h
//  FabFurnish
//
//  Created by Avneesh.minocha on 05/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (device)
+(NSString *)devicename;
+ (NSString *)getIPAddress;

+ (NSString*) deviceUUID;

- (NSString*)trimWhiteSpacesAndNewline;

@end
