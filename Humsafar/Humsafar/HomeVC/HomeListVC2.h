//
//  HomeListVC2.h
//  Humsafar
//
//  Created by Rahul on 10/26/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HomeListVC2Type) {
    HomeListVC2TypeEmergencie,
    HomeListVC2TypeIssue
};

@interface HomeListVC2 : UIViewController

@property (nonatomic) HomeListVC2Type homeListVC2Type;

@end
