//
//  UIView+FF.m
//  FabFurnish
//
//  Created by Amit Kumar on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "UIView+FF.h"

#define kEmptyView 5001
#define kMessageLabel 5002

@implementation UIView (FF)

-(void) addEmptyViewWithMessage:(NSString*)message andTarget:(id)target selector:(SEL)selector{
    
    UIView *blankView = [self viewWithTag:kEmptyView];
    
    if (!blankView) {
        blankView = [[UIView alloc] init];
        blankView.tag = kEmptyView;
    }
    
    [blankView setFrame:CGRectMake(0, 0, self.bounds.size.width, ScreenHeight)];
    [blankView setBackgroundColor:[UIColor whiteColor]];
    
    [self removePreviousMessageLabel];
    UILabel *labelMessage = [[UILabel alloc] init];
    labelMessage.tag = kMessageLabel;
    labelMessage.textAlignment = NSTextAlignmentCenter;
    labelMessage.text = message;
    labelMessage.font = [UIFont ffRegularFontWithSize:16];
    [blankView addSubview:labelMessage];
    labelMessage.center = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    labelMessage.bounds = CGRectMake(0, 0, blankView.bounds.size.width, 40);
    
    if(selector){
        UIButton *goToLogin = [[UIButton alloc] init];
        [goToLogin addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [goToLogin setTitle:@"GO TO LOGIN" forState:UIControlStateNormal];
        [goToLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [goToLogin.titleLabel setFont:[UIFont ffRegularFontWithSize:ffFontSize16px]];
        goToLogin.tintColor = [UIColor ffOrangeColor];
        goToLogin.backgroundColor = [UIColor ffOrangeColor];
//        goToLogin.layer.borderWidth = 0.3;
        goToLogin.layer.cornerRadius = 2;
        [blankView addSubview:goToLogin];
        goToLogin.bounds = CGRectMake(0, 0, 200, 40);
        goToLogin.center = CGPointMake(
                                       labelMessage.frame.size.width/2,
                                       labelMessage.frame.origin.y
                                       + labelMessage.frame.size.height
                                       + 10
                                       + goToLogin.frame.size.height/2);
    }
    
    [self addSubview:blankView];
}

-(void) removeEmptyView{
    UIView *emptyView = [self viewWithTag:kEmptyView];
    [emptyView removeFromSuperview];
    emptyView = nil;
}

-(void) removePreviousMessageLabel{
    UILabel *labelMessage = (UILabel*)[self viewWithTag:kMessageLabel];
    if (labelMessage) {
        [labelMessage removeFromSuperview];
        labelMessage = nil;
    }
}

- (void)addLeftMenuGradient {
    CAGradientLayer *gradientLayer = [self leftMenuGradient];
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (CAGradientLayer *)leftMenuGradient{
    
    UIColor *topColor = [UIColor colorWithRed:250.0/255 green:245.0/255 blue:238.0/255 alpha:1];
    UIColor *bottomColor = [UIColor colorWithRed:196.0/255 green:188.0/255 blue:177.0/255 alpha:1];
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    
    return gradientLayer;
}


- (void)addBlackGradientToTitleView {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CGRect frame = self.bounds;
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    gradientLayer.frame = frame;
    
    UIColor *colorOne = [UIColor colorWithWhite:1 alpha:0.02];
    UIColor *colorTwo = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[colorOne CGColor], (id)[colorTwo CGColor], nil];
    NSArray *gradientLocations = @[@0.0,@1.0];
    gradientLayer.locations = gradientLocations;

    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)addInvertedBlackGradientToTitleView {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    CGRect frame = self.bounds;
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    gradientLayer.frame = frame;
    
    UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIColor *colorTwo = [UIColor colorWithWhite:1 alpha:0.02];
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[colorOne CGColor], (id)[colorTwo CGColor], nil];
    NSArray *gradientLocations = @[@0.0,@1.0];
    gradientLayer.locations = gradientLocations;
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
}


- (void)setViewRadius:(CGFloat)radius {

    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}


- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(CGColorRef)color {
    
    [self setViewRadius:radius];
    self.layer.borderColor = color;
    self.layer.borderWidth = width;
}




@end
