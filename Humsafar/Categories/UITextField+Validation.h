//
//  UITextField+Validation.h
//  FabFurnish
//
//  Created by Avneesh.minocha on 13/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFValidationResult.h"

@interface UITextField (Validation)
-(BOOL)isMobileNumberValid;
-(BOOL)isPasswordValid;
-(BOOL)isEmailValid;
- (BOOL)isEmptyField;

//--------------------------------
-(FFValidationResult *) validateType:(eFieldValidationType) validationTypes;

//-(eFieldValidationType) validateTextWithType:(eFieldValidationType) validationTypes;



@end
