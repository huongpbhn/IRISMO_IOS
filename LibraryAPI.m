//
//  LibraryAPI.m
//  IRISLibrary
//
//  Created by Ricky Lee on 1/8/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "LibraryAPI.h"

@implementation LibraryAPI

+ (id)sharedInit {
    static LibraryAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
    [super dealloc];
}


@end

/*************************************************************
 *
 *
 *  DO NOT MODIFY!!!!
 *  INHERIT ONLY!!!!!
 *
 *
 *************************************************************/
