//
//  CallListVC.h
//  Humsafar
//
//  Created by B0081006 on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CallListVCType) {
    CallListVCTypeMedical,
    CallListVCTypePolice,
    CallListVCTypeTransport,
    CallListVCTypeOther,
};


@interface CallListVC : UIViewController<UITextFieldDelegate>

@property (assign) CallListVCType callListVCType;
@property (weak, nonatomic) IBOutlet UITextField *txtField_search;

@end
