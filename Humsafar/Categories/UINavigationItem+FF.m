//
//  UINavigationItem+FF.m
//  FabFurnish
//
//  Created by Avneesh.minocha on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "UINavigationItem+FF.h"

@implementation UINavigationItem (FF)

#pragma mark - BackButton
-(UIBarButtonItem *)ffbackBarbuttonitem:(SEL)lselector withtarget:(id)target
{
    UIImage *backimg = [UIImage imageNamed:@"ArrowBack"];
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc] initWithImage:backimg style:UIBarButtonItemStylePlain target:target action:lselector];
    [leftbtn setTintColor:[UIColor ffGrayColor]];
    return leftbtn;
}

#pragma mark - Home Left Slider button
-(UIBarButtonItem *)ffsliderBarbuttonitem:(SEL)lselector withtarget:(id)target
{
    UIImage *image = [UIImage imageNamed:@"Menu"];
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:lselector];
    [leftbtn setTintColor:[UIColor ffGrayColor]];
    return leftbtn;

}

#pragma mark - Right Search button
-(UIBarButtonItem *)ffrightSearchBarbuttonitem:(SEL)rselector withtarget:(id)target
{
    UIImage *searchimage = [UIImage imageNamed:@"search"];
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithImage:searchimage style:UIBarButtonItemStylePlain target:target action:rselector];
    [rightbtn setTintColor:[UIColor ffGrayColor]];
    return rightbtn;
}

// Right bar code button
-(UIBarButtonItem *)ffrightQRCodebuttonitem:(SEL)rselector withtarget:(id)target
{
    UIImage *searchimage = [UIImage imageNamed:@"QR_Icon"];
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithImage:searchimage style:UIBarButtonItemStylePlain target:target action:rselector];
    [rightbtn setTintColor:[UIColor ffGrayColor]];
    [rightbtn setImageInsets:UIEdgeInsetsMake(0, -30, 0, -65)];
    return rightbtn;
}

// Right bar code button
-(UIBarButtonItem *)ffNegativeSpacerbuttonitem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    return negativeSpacer;
}


#pragma mark - Titleview With Logo
-(UIButton *)fftitleViewWithTitle:(NSString *)string
{
    UIButton *logoHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoHeader setFrame:CGRectMake(0,0, 125, 44)];
    [logoHeader setImage:[UIImage imageNamed:@"Logo"] forState:UIControlStateNormal];
    [logoHeader setTitle:string forState:UIControlStateNormal];
    [logoHeader.titleLabel setFont:[UIFont ffLightFontWithSize:ffFontSize16px]];
    [logoHeader setTitleColor:[UIColor ffDarkGrayColor] forState:UIControlStateNormal];
    logoHeader.userInteractionEnabled = NO;

    logoHeader.imageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0);
    logoHeader.titleEdgeInsets = UIEdgeInsetsMake(0.0, 12, 0.0, 0.0);
    return logoHeader;

}

#pragma mark - Use to make the filter header (not in use now design change)
-(void)configureFilterHeaderWithLeftSelector:(SEL)lselector rightSelector:(SEL)rselector withtarget:(id)target withTitle:(NSString *)string
{
    [self configureTitle:string];
    
    UIButton *clearbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearbtn setFrame:CGRectMake(0, 0, 40, 44)];
    [clearbtn setTitleColor:[UIColor ffOrangeColor] forState:UIControlStateNormal];
    [clearbtn setTitle:@"Clear all" forState:UIControlStateNormal];

    [clearbtn addTarget:target action:lselector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc] initWithCustomView:clearbtn];
    self.leftBarButtonItem = leftbtn;
    
    
    UIButton *donebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [donebtn setFrame:CGRectMake(0, 0, 40, 44)];
    [donebtn setTitle:@"Done" forState:UIControlStateNormal];
    [donebtn setTitleColor:[UIColor ffOrangeColor] forState:UIControlStateNormal];
    [donebtn addTarget:target action:rselector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithCustomView:donebtn];
    self.rightBarButtonItem = rightbtn;

    
}
#pragma mark - Use to make the search type header
-(void)configureSearchHeaderWithLeftSelector:(SEL)lselector rightSelector:(SEL)rselector withtarget:(id)target withTitle:(NSString *)string
{
    [self configureTitle:string];
    self.leftBarButtonItem = [self ffbackBarbuttonitem:lselector withtarget:target];
    
    UIBarButtonItem *spaceFix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
    spaceFix.width = -5;
    
    self.rightBarButtonItems = @[spaceFix, [self ffQRcodeBarbuttonitem:rselector withtarget:target]];
//    self.rightBarButtonItem = ;
}

-(UIBarButtonItem *)ffQRcodeBarbuttonitem:(SEL)buttonAction withtarget:(id)target
{
    UIImage *searchimage = [UIImage imageNamed:@"QR_Icon"];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithImage:searchimage style:UIBarButtonItemStylePlain target:target action:buttonAction];
    [barButton setTintColor:[UIColor ffGrayColor]];
    
    return barButton;
}


#pragma mark - Use to make the home type header
-(void)configureHomeHeaderWithLeftSelector:(SEL)lselector rightSelectorArray:(NSArray*)arrayOfRselector withtarget:(id)target withTitle:(NSString *)string
{
    [self setTitleView:[self fftitleViewWithTitle:string]];
    self.leftBarButtonItem = [self ffsliderBarbuttonitem:lselector withtarget:target];
    self.rightBarButtonItems = [NSArray arrayWithObjects:
                                [self ffrightSearchBarbuttonitem:NSSelectorFromString([arrayOfRselector objectAtIndex:0]) withtarget:target],
                                [self ffrightQRCodebuttonitem:NSSelectorFromString([arrayOfRselector objectAtIndex:1]) withtarget:target],
                                nil];
}

// Only Back Button and Title with Logo
-(void)configureHomeHeaderWithLeftSelector:(SEL)lselector withtarget:(id)target withTitle:(NSString *)string
{
    [self setTitleView:[self fftitleViewWithTitle:string]];
    self.leftBarButtonItem = [self ffbackBarbuttonitem:lselector withtarget:target];
}

// Only Back Button and Title
-(void)configureHeaderWithoutLogoWithLeftSelector:(SEL)lselector withtarget:(id)target withTitle:(NSString *)string
{
    [self configureTitle:string];
    self.leftBarButtonItem = [self ffbackBarbuttonitem:lselector withtarget:target];
}

// Only Back Button, DOne button and Title
-(void)configureHeaderWithLeftSelector:(SEL)lselector DoneButtonAtRightSelector:(SEL)rselector target:(id)target withTitle:(NSString *)string
{
    [self configureTitle:string];
    self.leftBarButtonItem = [self ffbackBarbuttonitem:lselector withtarget:target];
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain target:target action:rselector];
    [rightbtn setTintColor:[UIColor ffOrangeColor]];
    
    self.rightBarButtonItem = rightbtn;
}


#pragma mark - Use to make the catalog type header
-(void)configureHomeCatalogueWithLeftSelector:(SEL)lselector rightSelector:(SEL)rselector withtarget:(id)target withTitle:(NSString *)string
{
    [self configureTitle:string];
    self.leftBarButtonItem = [self ffbackBarbuttonitem:lselector withtarget:target];
    self.hidesBackButton  = YES;
    if (rselector) {
        self.rightBarButtonItem = [self ffrightSearchBarbuttonitem:rselector withtarget:target];
    }
}

#pragma mark - Use to make the WishList type header
-(void)configureWishListHeaderWithLeftSelector:(SEL)lselector rightSelector:(SEL)rselector withtarget:(id)target withTitle:(NSString *)string
{
    [self configureTitle:string];
//    UIImage *searchimage = [UIImage imageNamed:@"search"];
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"Clear all"
                                                                 style:UIBarButtonItemStylePlain target:target action:rselector];
    [rightbtn setTintColor:[UIColor ffOrangeColor]];

    self.rightBarButtonItem = rightbtn;
}

#pragma mark - Use to make the titleview with only title or to change title of already configured Navigation Header
-(void)configureTitle:(NSString *)string
{
    if ((string != nil) || (string != [NSNull null])) {
     
        UILabel *headerlbl = [[UILabel alloc] init];
        [headerlbl setTextAlignment:NSTextAlignmentCenter];
        [headerlbl setText:string];
        [headerlbl setFont:[UIFont ffLightFontWithSize:ffFontSize16px]];
        [headerlbl sizeToFit];
        
        [self setTitleView:headerlbl];
    }
}

@end
