//
//  UIFont+FF.h
//  FabFurnish
//
//  Created by Avneesh.minocha on 04/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    ffFontSize10px = 10,
    DEPRECATEDEDFONT11,
    ffFontSize12px,
    ffFontSize13px,
    ffFontSize14px,
    DEPRECATEDEDFONT15,
    ffFontSize16px,
} ffFontSize;


@interface UIFont (FF)
+ (UIFont *)ffLightFontWithSize:(ffFontSize)fontSize;
+ (UIFont *)ffLightItalicFontWithSize:(ffFontSize)fontSize;
+ (UIFont *)ffRegularFontWithSize:(ffFontSize)fontSize;
+ (UIFont *)ffSemiBoldFontWithSize:(ffFontSize)fontSize;
@end
