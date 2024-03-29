//
//  ShareActivityController.m
//  B88C
//
//  Created by Ricky Lee on 4/28/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareActivityController.h"
#import "CheckSystem.h"

@implementation ShareActivityController

@synthesize delegate;

-(void)startSharing:(UIViewController *)vc withSubject:(NSString *)subject withDetails:(NSArray *)array withExcludeActivities:(NSArray *) excludeActivities {
    self.delegate = vc;
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    [avc setValue:subject forKey:@"subject"];
    
    avc.excludedActivityTypes = excludeActivities;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [avc setCompletionWithItemsHandler:^(NSString *act, BOOL done, NSArray *returnedItems, NSError *e)
         {
             NSLog(@"social sharing action type %@",act);
             
             if ( done ) {
                 if ([delegate respondsToSelector:@selector(finishSocialSharing:)]) {
                     [delegate finishSocialSharing:act];
                 }
             }
             else {
                 NSLog(@"Fail social sharing");
                 // didn't succeed.
                 if ([delegate respondsToSelector:@selector(failSocialSharing:)]) {
                     [delegate failSocialSharing:act];
                 }
             }
         }];
    }
    else {
        [avc setCompletionHandler:^(NSString *act, BOOL done)
         {
             
             NSLog(@"social sharing action type %@",act);
             
             if ( done ) {
                 if ([delegate respondsToSelector:@selector(finishSocialSharing:)]) {
                     [delegate finishSocialSharing:act];
                 }
             }
             else {
                 NSLog(@"Fail social sharing");
                 // didn't succeed.
                 if ([delegate respondsToSelector:@selector(failSocialSharing:)]) {
                     [delegate failSocialSharing:act];
                 }
             }
         }];
    }
    [vc presentViewController:avc animated:YES completion:nil];
    [avc release];

}

-(void)startSharing:(UIViewController *)vc withSubject:(NSString *)subject withDetails:(NSArray *)array {
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    [avc setValue:subject forKey:@"subject"];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    [avc release];
    [self startSharing:vc withSubject:subject withDetails:array withExcludeActivities:excludeActivities];
}

@end
