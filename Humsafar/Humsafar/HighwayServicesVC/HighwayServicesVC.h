//
//  HighwayServicesVC.h
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HighwayServicesVCType) {
    HighwayServicesVCTypeCAR,
    HighwayServicesVCTypeHOSPITAL,
    HighwayServicesVCTypeRESTAURANT,
    HighwayServicesVCTypeGAS,
    HighwayServicesVCTypePHARMACY
};

@interface HighwayServicesVC : UIViewController

@property (assign) HighwayServicesVCType highwayServicesVCType;

@end
