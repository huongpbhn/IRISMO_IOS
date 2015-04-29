//
//  TouchID.h
//  B88C
//
//  Created by Ricky Lee on 4/17/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchID : NSObject

+ (void)startTouchID:(NSString *)reason completionHandler:(void(^) (BOOL successed))completionHandler;

@end
