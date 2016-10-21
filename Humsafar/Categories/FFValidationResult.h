//
//  ValidationError.h
//  FabFurnish
//
//  Created by Amit Kumar on 05/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// Text Field Validation
typedef enum {
    eFieldValidationTypeValid = 0,
    eFieldValidationTypeEmpty = 1,
    eFieldValidationTypeTextOnly = 2,
    eFieldValidationTypeNumberOnly = 4,
    eFieldValidationTypeMobileNumber = 8,
    eFieldValidationTypeEmailID = 16,
    eFieldValidationTypePassword = 32,
    eFieldValidationTypeMinSixMaxThirtyLength = 64,
    eFieldValidationTypeMinSixMaxFiftyLength = 128,
    eFieldValidationTypeUnknown = 256,
    
} eFieldValidationType;




@interface FFValidationResult : NSObject

@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, assign) eFieldValidationType validationType;


@end
