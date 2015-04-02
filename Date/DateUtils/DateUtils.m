//
//  CountDownTimer.m
//  B88C
//
//  Created by Ricky Lee on 4/2/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSDate *)convertToDate:(NSString *)dateStr withFormat:(NSString *)format {
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat release];
    return date;
}

+ (NSDate *)getcurrentDateWithFormat:(NSString *)format {
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:format];
    NSString* currentDateStr = [DateFormatter stringFromDate:[NSDate date]];
    
    return [DateUtils convertToDate:currentDateStr withFormat:format];
    
}

+ (NSString *)compareDate:(NSDate *)currentDate WithDate:(NSDate *)endDate {
    
    NSTimeInterval time = (double)[endDate timeIntervalSinceDate:currentDate];
    NSInteger totalSeconds = time;
    
    if (totalSeconds < 0) {
        return nil;
    }
    
    int days = (int)totalSeconds/(24*60*60);
    int seconds = totalSeconds % (24*60*60);
    int hrs = seconds/(60*60);
    seconds = seconds % (60*60);
    int mins = seconds/60;
    seconds = seconds % 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%i days %i:%i:%i", days, hrs, mins, seconds];
    
    return timeStr;
    
}

@end
