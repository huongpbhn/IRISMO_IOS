//
//  CheckSystem.h
//  Academy
//
//  Created by Ricky Lee on 9/1/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define SCREEN_HEIGHT [[UIScreen mainScreen ] bounds].size.height
#define IS_IPHONE_4  ( IS_IPHONE && SCREEN_HEIGHT  < 568.0)
#define IS_IPHONE_5  ( IS_IPHONE && SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6  ( IS_IPHONE && SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P ( IS_IPHONE && SCREEN_HEIGHT == 736.0)




@interface CheckSystem : NSObject

@end
