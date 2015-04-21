//
//  NSString+String_Validation.m
//  B88C
//
//  Created by Ricky Lee on 4/17/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

+ (BOOL)validateString:(id)checkString {
    
    if (![checkString isEqual:(id)[NSNull null]] && [checkString length] > 0) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
