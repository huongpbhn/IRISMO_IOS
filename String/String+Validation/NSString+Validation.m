//
//  NSString+String_Validation.m
//  B88C
//
//  Created by Ricky Lee on 4/17/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

+ (NSString *)validateString:(id)checkString {
    
    if ([checkString isKindOfClass:[NSString class]] && ![checkString isEqual:(id)[NSNull null]] && [checkString length] > 0) {
        return checkString;
    }
    else {
        return nil;
    }
}

@end
