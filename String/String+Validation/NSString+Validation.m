//
//  NSString+String_Validation.m
//  B88C
//
//  Created by Ricky Lee on 4/17/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

#warning issue with NULL
- (BOOL)isValid {
    if (![self isEqual:(id)[NSNull null]] && [self length] > 0) {
        return YES;
    }
    else {
        return NO;
    }
    
}

@end
