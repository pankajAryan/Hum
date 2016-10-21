//
//  UIColor+FF.h
//  FabFurnish
//
//  Created by Avneesh.minocha on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FF)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+(UIColor *)ffOrangeColor;
+(UIColor *)ffDarkGrayColor;
+(UIColor *)ffGrayColor;
+(UIColor *)fflightGrayColor;

+(UIColor *)ffTextDarkGrayColor;
+(UIColor *)fftextLightGrayColor;

+(UIColor *)ffTextFieldPlaceholderColor;

@end
