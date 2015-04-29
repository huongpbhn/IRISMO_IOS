//
//  CoreDataUtils.m
//  FailedBankCD
//
//  Created by Ricky Lee on 4/29/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "CoreDataUtils.h"

@implementation CoreDataUtils

@synthesize context;

+ (id)sharedInstance {
    static CoreDataUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}


- (NSArray *)fetchCoreData:(NSString *)name {
    if (!context) {
        NSLog(@"ERROR: there is no context!!");
        return nil;
    }
    NSError *error;
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:name inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    return [context executeFetchRequest:fetchRequest error:&error];
    
}

- (void)flushCoreData:(NSString *)name {
    if (!context) {
        NSLog(@"ERROR: there is no context!!");
        return;
    }
    
    NSArray *flushObjects = [self fetchCoreData:name];
    
    for (NSManagedObject * aManagedObject in flushObjects) {
        [context deleteObject:aManagedObject];
    }
    
    NSError *saveError = nil;
    [context save:&saveError];
}



@end
