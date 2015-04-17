//
//  TouchID.m
//  B88C
//
//  Created by Ricky Lee on 4/17/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchID

+ (void)startTouchID:(NSString *)reason completionHandler:(void(^) (BOOL successed))completionHandler {
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = reason;
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    // User authenticated successfully, take appropriate action
                                    completionHandler(YES);
                                } else {
                                    // User did not authenticate successfully, look at error and take appropriate action
                                    completionHandler(NO);
                                }
                            }];
    } else {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        completionHandler(NO);
    }
}

@end
