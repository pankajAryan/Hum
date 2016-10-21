//
//  UIColor+FF.m
//  FabFurnish
//
//  Created by Avneesh.minocha on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "UIColor+FF.h"

@implementation UIColor (FF)



// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(UIColor *)ffOrangeColor
{
    return [UIColor colorWithRed:255.0/255 green:150.0/255 blue:0/255 alpha:1.0];
}
+(UIColor *)ffDarkGrayColor
{
    return [UIColor colorWithRed:57.0/255 green:57.0/255 blue:57.0/255 alpha:1.0];
}
+(UIColor *)ffGrayColor
{
    return [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
}
+(UIColor *)fflightGrayColor
{
    return [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
}


+(UIColor *)ffTextDarkGrayColor
{
    return [UIColor colorWithRed:52.0/255 green:52.0/255 blue:52.0/255 alpha:1.0];
}
+(UIColor *)fftextLightGrayColor
{
    return [UIColor colorWithRed:105.0/255 green:105.0/255 blue:105.0/255 alpha:1.0];
}

+(UIColor *)ffTextFieldPlaceholderColor
{
    return [UIColor colorWithRed:199.0/255 green:199.0/255 blue:205.0/255 alpha:1.0];
}

@end
