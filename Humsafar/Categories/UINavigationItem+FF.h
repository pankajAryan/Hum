//
//  UINavigationItem+FF.h
//  FabFurnish
//
//  Created by Avneesh.minocha on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (FF)
-(void)configureFilterHeaderWithLeftSelector:(SEL)lselector rightSelector:(SEL)rselector withtarget:(id)target withTitle:(NSString *)string;
-(void)configureHomeHeaderWithLeftSelector:(SEL)lselector rightSelectorArray:(NSArray*)arrayOfRselector withtarget:(id)target withTitle:(NSString *)string;

// Only Back Button and Title Logo
-(void)configureHomeHeaderWithLeftSelector:(SEL)lselector withtarget:(id)target withTitle:(NSString *)string;

// Only Back Button and Title
-(void)configureHeaderWithoutLogoWithLeftSelector:(SEL)lselector withtarget:(id)target withTitle:(NSString *)string;
-(void)configureHomeCatalogueWithLeftSelector:(SEL)lselector rightSelector:(SEL)rselector withtarget:(id)target withTitle:(NSString *)string;
-(void)configureWishListHeaderWithLeftSelector:(SEL)lselector rightSelector:(SEL)rselector withtarget:(id)target withTitle:(NSString *)string;
-(void)configureSearchHeaderWithLeftSelector:(SEL)lselector rightSelector:(SEL)rselector withtarget:(id)target withTitle:(NSString *)string;

-(void)configureHeaderWithLeftSelector:(SEL)lselector DoneButtonAtRightSelector:(SEL)rselector target:(id)target withTitle:(NSString *)string;


-(void)configureTitle:(NSString *)string;

@end
