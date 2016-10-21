//
//  HomeListVC.h
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HomeListVCType) {
    HomeListVCTypeJams,
    HomeListVCTypeDiversions,
    HomeListVCTypeVIPMovements,
    HomeListVCTypeSuggestions
};


@interface HomeListVC : UIViewController

@property (assign) HomeListVCType homeListVCType;

@end
