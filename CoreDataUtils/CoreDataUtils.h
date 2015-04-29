//
//  CoreDataUtils.h
//  FailedBankCD
//
//  Created by Ricky Lee on 4/29/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataUtils : NSObject

@property (nonatomic, retain) NSManagedObjectContext *context;

+ (id)sharedInstance;

- (NSArray *)fetchCoreData:(NSString *)name;
- (void)flushCoreData:(NSString *)name;

@end
