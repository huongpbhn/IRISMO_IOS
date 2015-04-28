//
//  ShareActivityController.h
//  B88C
//
//  Created by Ricky Lee on 4/28/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShareActivityControllerDelegate <NSObject>

@optional
- (void)finishSocialSharing:(NSString *)activityType;
- (void)failSocialSharing:(NSString *)activityType;

@end

@interface ShareActivityController : NSObject {
    id delegate;
}

@property(assign)id delegate;

-(void)startSharing:(id)vc withSubject:(NSString *)subject withDetails:(NSArray *)array;

@end
