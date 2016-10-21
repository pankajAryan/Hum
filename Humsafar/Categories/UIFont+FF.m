//
//  UIFont+FF.m
//  FabFurnish
//
//  Created by Avneesh.minocha on 04/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "UIFont+FF.h"

@implementation UIFont (FF)

+ (UIFont *)ffLightFontWithSize:(ffFontSize)fontSize
{
    return [UIFont fontWithName:@"OpenSans-Light" size:[self fontSize:fontSize]];
}
+ (UIFont *)ffLightItalicFontWithSize:(ffFontSize)fontSize
{
    return [UIFont fontWithName:@"OpenSans-LightItalic" size:[self fontSize:fontSize]];
}
+ (UIFont *)ffRegularFontWithSize:(ffFontSize)fontSize
{
    return [UIFont fontWithName:@"OpenSans" size:[self fontSize:fontSize]];
}
+ (UIFont *)ffSemiBoldFontWithSize:(ffFontSize)fontSize
{
    return [UIFont fontWithName:@"OpenSans-Semibold" size:[self fontSize:fontSize]];
}

+(CGFloat)fontSize:(ffFontSize)size
{
    switch (size) {
        case ffFontSize10px:
            return 10.0f;
            break;
            
        case ffFontSize12px:
            return 12.0f;
            break;
            
        case ffFontSize13px:
            return 13.0f;
            break;

        case ffFontSize14px:
            return 14.0f;
            break;

        case ffFontSize16px:
            return 16.0f;
            break;

        default:
            
            return 12.0;
            break;
    }
}

@end
