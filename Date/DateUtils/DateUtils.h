//
//  CountDownTimer.h
//  B88C
//
//  Created by Ricky Lee on 4/2/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DateUtils : NSObject

+ (NSDate *)convertToDate:(NSString *)dateStr withFormat:(NSString *)format;
+ (NSDate *)getcurrentDateWithFormat:(NSString *)format;
+ (NSString *)compareDate:(NSDate *)currentDate WithDate:(NSDate *)endDate;

@end
