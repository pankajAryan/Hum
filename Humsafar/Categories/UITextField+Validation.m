//
//  UITextField+Validation.m
//  FabFurnish
//
//  Created by Avneesh.minocha on 13/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//


//---------------------------------------------------------------


// Error messages
#define kMessageToEnsurePresence @" can not be Empty"
#define kMessageToEnsureTextOnly @" accepts only characters"
#define kMessageToEnsureNumberOnly @"Kindly enter only numbers in "
#define kMessageToEnsureValidMobile @"Kindly enter valid Mobile Number"
#define kMessageToEnsureValidEmail @" is not valid"
#define kMessageToEnsureSamePassword @"Password does not match"
#define kMessageToEnsureMinSixAndMaxThirty @" should be greater than 6 and less than 30 characters"
#define kMessageToEnsureMinSixAndMaxFifty @" should be greater than 6 and less than 50 characters"
#define kMessageToAppendCharactes @" characters"


#define kMessageToEnsureRangeOfInput @"Should be between %d and %d characters !"
#define kMessageToEnsureUnknown @"Somthing in not Valid!"

#define kRegexMobileNumber @"[0-9]{10}"
#define kRegexEmail @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$"


//---------------------------------------------------------------
#import "UITextField+Validation.h"

#define kRegexEmail @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$"


@implementation UITextField (Validation)

-(BOOL)isMobileNumberValid
{
    if ([self.text length] >= 10)
        return YES;
    else
        return NO;
}
-(BOOL)isPasswordValid
{
    BOOL isValidLength = NO;
    isValidLength =  (self.text.length >=6 && self.text.length <= 30)  ? YES : NO;
    return isValidLength;
}

-(BOOL)isEmailValid
{
    BOOL isValidFormat = NO;
    BOOL isValidLength = NO;

    isValidLength =  (self.text.length >=6 && self.text.length <= 50)  ? YES : NO;
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kRegexEmail];
    isValidFormat =  [emailTest evaluateWithObject:self.text];
    
    
    if (isValidFormat && isValidLength)
        return YES;
    else
        return NO;
}

- (BOOL)isEmptyField {

    if ([[self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) { // Empty String
        
        return YES;
    }
    
    return NO;
}

//--------------------------------------------------------------------



-(FFValidationResult *) validateType:(eFieldValidationType) validationTypes {
    
    FFValidationResult *result = [[FFValidationResult alloc] init];
    eFieldValidationType resultType = [self validateTextWithType:validationTypes];
    
    if (resultType == eFieldValidationTypeValid) {
        // TextField is valid
        result.isValid = YES;
    }else{
        // TextField is not valid
        result.isValid = NO;
        result.errorMessage = [UITextField errorMessageFor:self.placeholder type:resultType];
        result.errorCode = validationTypes;
    }
    return result;
}

-(eFieldValidationType) validateTextWithType:(eFieldValidationType) validationTypes
{
    eFieldValidationType validationResult = eFieldValidationTypeValid;
    
    if (validationTypes & eFieldValidationTypeEmpty) {
        if ([[self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) { // Empty String
            validationResult = validationResult | eFieldValidationTypeEmpty;
            // validationResult = 0000000 | 0000001
        }
        else
        {
            
            if (validationTypes & eFieldValidationTypeTextOnly) {
                if (![self isTextAndSpaceOnly:self.text]) {
                    validationResult = validationResult | eFieldValidationTypeTextOnly;
                }
            }
            
            if (validationTypes & eFieldValidationTypeNumberOnly) {
                if (![self isNumericOnly:self.text]) {
                    validationResult = validationResult | eFieldValidationTypeNumberOnly;
                }
            }
            
            if (validationTypes & eFieldValidationTypeMobileNumber) {
                if (![self isValidMobileNumber:self.text]) {
                    validationResult = validationResult | eFieldValidationTypeMobileNumber;
                }
            }
            
            if (validationTypes & eFieldValidationTypeEmailID) {
                if (![self isValidEmail:self.text]) {
                    validationResult = validationResult | eFieldValidationTypeEmailID;
                }
            }
            
            if (validationTypes & eFieldValidationTypePassword) {
                if (![self isConfirmPasswordSame]) {
                    validationResult = validationResult | eFieldValidationTypePassword;
                }
            }
            
            if (validationTypes & eFieldValidationTypeMinSixMaxThirtyLength) {
                if (![self isValidMinSixMaxThirty:self.text]) {
                    validationResult = validationResult | eFieldValidationTypeMinSixMaxThirtyLength;
                }
            }
            
            if (validationTypes & eFieldValidationTypeMinSixMaxFiftyLength) {
                if (![self isValidMinSixMaxFifty:self.text]) {
                    validationResult = validationResult | eFieldValidationTypeMinSixMaxFiftyLength;
                }
            }
        }
    }
    else
    {
        // This is logic is added because mobile can be empty. and if it is not empty, it should be 11 digit only.
        if (validationTypes == eFieldValidationTypeMobileNumber){
            if (self.text.length == 0 ||
                self.text.length == 11) {
                
                NSInteger mobileNumber = [self.text integerValue];
                NSString *moblieNumberString = [NSString stringWithFormat:@"%ld",(long)mobileNumber];
                if ((moblieNumberString.length == 11) ||
                    ([moblieNumberString isEqualToString:@"0"])
                    ) {
                    // Valid mobile Number
                }else{
                    validationResult = eFieldValidationTypeMobileNumber;
                }
            }else{
                validationResult = eFieldValidationTypeMobileNumber;
            }
        }
    }
    
    return validationResult;
    
}



+ (NSString *) errorMessageFor:(NSString *) fieldName type:(eFieldValidationType) validationResult{
    NSMutableString *errorMessage = [NSMutableString new];
    
    fieldName = [fieldName  stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"*"]];
    if (fieldName.length == 0) {
        fieldName = [[NSString alloc] initWithFormat:@"Field "];
    }
    
    if (validationResult & eFieldValidationTypeEmpty) {
        // userName can not be empty
        [errorMessage appendFormat:@"%@%@ !",fieldName, kMessageToEnsurePresence];
    }else{
        
        if (validationResult & eFieldValidationTypeTextOnly) {
            [errorMessage appendFormat:@"%@%@ !",fieldName,kMessageToEnsureTextOnly];
        }
        
        if (validationResult & eFieldValidationTypeNumberOnly) {
            [errorMessage appendFormat:@"%@%@ !",kMessageToEnsureNumberOnly,fieldName];
        }
        
        if (validationResult & eFieldValidationTypeMobileNumber) {
            [errorMessage appendFormat:@"%@ !",kMessageToEnsureValidMobile];
        }
        
        if (validationResult & eFieldValidationTypeEmailID) {
            [errorMessage appendFormat:@"%@%@ !",fieldName,kMessageToEnsureValidEmail];
        }
        
        if (validationResult & eFieldValidationTypePassword) {
            [errorMessage appendFormat:@"%@ !",kMessageToEnsureSamePassword];
        }
        
        if (validationResult & eFieldValidationTypeMinSixMaxThirtyLength) {
            [errorMessage appendFormat:@"%@,%@",fieldName,kMessageToEnsureMinSixAndMaxThirty];
        }
        
        if (validationResult & eFieldValidationTypeMinSixMaxFiftyLength) {
            [errorMessage appendFormat:@"%@%@ !",fieldName,kMessageToEnsureMinSixAndMaxFifty];
        }
    }
    
    return errorMessage;
}



-(BOOL) isTextAndSpaceOnly:(NSString *) text{
    
    NSMutableCharacterSet *textOnlyCharacterSet = [[NSCharacterSet letterCharacterSet] mutableCopy];
    NSCharacterSet *whiteSpaceCharacterSet = [NSCharacterSet whitespaceCharacterSet];
    // its only text and white space charater set
    [textOnlyCharacterSet formUnionWithCharacterSet:whiteSpaceCharacterSet];
    // inverted char set, unwanted
    NSCharacterSet *unwantedCharacters = [textOnlyCharacterSet invertedSet];
    // if unwanted NSnotfound means wanted found.
    return ([text rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

-(BOOL) isNumericOnly:(NSString *)text{
    NSCharacterSet *decimalCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
    // inverted char set, unwanted
    NSCharacterSet *unwantedCharacters = [decimalCharacterSet invertedSet];
    // if unwanted NSnotfound means wanted found.
    return ([text rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
}

-(BOOL) isValidMobileNumber:(NSString *) mobile{
    BOOL validMobile = NO;
    if (mobile.length == 11) {
        NSCharacterSet *decimalCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
        // inverted char set, unwanted
        NSCharacterSet *unwantedCharacters = [decimalCharacterSet invertedSet];
        // if unwanted NSnotfound means wanted found.
        validMobile = ([mobile rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound) ? YES : NO;
    }else{
        validMobile = NO;
    }
    return validMobile;
}

-(BOOL) isValidEmail:(NSString *) email{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kRegexEmail];
    return [emailTest evaluateWithObject:email];
}

-(BOOL) isConfirmPasswordSame{
    // implement in same class
    return YES;
}

- (BOOL) isValidMinSixMaxThirty:(NSString *) text{
    return (text.length >=6 && text.length <= 30)  ? YES : NO;
}

- (BOOL) isValidMinSixMaxFifty:(NSString *) text{
    return (text.length >=6 && text.length <= 50)  ? YES : NO;
}

-(BOOL) validatePassword:(NSString *) paswword withOtherPassword:(NSString *) otherPassword{
    if (![paswword isEqualToString:otherPassword])
        return YES;
    else
        return NO;
}


@end
