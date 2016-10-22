//
//  RoadSafetyEducationVC.h
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RoadSafetyEducationVCType) {
    RoadSafetyEducationVCTypeVideos,
    RoadSafetyEducationVCTypePDFs
};

@interface RoadSafetyEducationVC : UIViewController

@property (assign) RoadSafetyEducationVCType roadSafetyEducationVCType;

@end
