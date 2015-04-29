//
//  CoreDataUtils.m
//  FailedBankCD
//
//  Created by Ricky Lee on 4/29/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "CoreDataUtils.h"

@implementation CoreDataUtils

@synthesize context, fetchedObjectsDict;

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
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        self.fetchedObjectsDict = dict;
        [dict release];
    }
    return self;
}

- (void)save {
    if (!context) {
        NSLog(@"ERROR: there is no context!!");
        return;
    }
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"ERROR: couldn't save: %@", [error localizedDescription]);
    }
}

#pragma mark - Fetch all Core Data
- (NSArray *)fetchCoreData:(NSString *)entityName {
    if (!context) {
        NSLog(@"ERROR: there is no context!!");
        return nil;
    }
    
    @try {
        NSLog(@"fetching Core Data....................");
        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:entityName inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        [fetchedObjectsDict setObject:fetchedObjects forKey:entityName];
        [fetchRequest release];
        
        return fetchedObjects;
    }
    @catch (NSException * e) {
        NSLog(@"Core Data Exception: %@", [e description]);
    }
    
    return nil;
    
}

#pragma mark - Flush all Core Data
- (void)flushCoreData:(NSString *)entityName {
    if (!context) {
        NSLog(@"ERROR: there is no context!!");
        return;
    }
    
    NSArray *flushObjects = [self fetchCoreData:entityName];
    
    for (NSManagedObject * aManagedObject in flushObjects) {
        [context deleteObject:aManagedObject];
    }
    
    [self save];
    NSLog(@"flush Core Data complete!");
    
}

#pragma mark - Filter using Predicate
//
// How to create Predicate tutorial
// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
//
// Predicate Format String Syntax
// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html#//apple_ref/doc/uid/TP40001795-CJBDBHCB
//
// Quick sample
// NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name LIKE %@) AND (city LIKE %@)", @"Test Bank*", @"Testville2"];
// NSArray *array = [coreData filterCoreData:@"FailedBankInfo" withPredicate:predicate];
//

- (NSArray *)filterCoreData:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    
    if (!context) {
        NSLog(@"ERROR: there is no context!!");
        return nil;
    }
    
    NSArray *fetchedObjects = [fetchedObjectsDict objectForKey:entityName];
    if (!fetchedObjects) {
        fetchedObjects = [self fetchCoreData:entityName];
    }
    
    NSArray *filtered = [fetchedObjects filteredArrayUsingPredicate:predicate];
    return filtered;
}

@end
