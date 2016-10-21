//
//  UIView+FF.h
//  FabFurnish
//
//  Created by Amit Kumar on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (FF)

-(void) addEmptyViewWithMessage:(NSString*)message andTarget:(id)target selector:(SEL)selector;
-(void) removeEmptyView;

-(void) addLeftMenuGradient;
- (void)addBlackGradientToTitleView;
- (void)addInvertedBlackGradientToTitleView;

- (void)setViewRadius:(CGFloat)radius;
- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(CGColorRef)color;

@end
