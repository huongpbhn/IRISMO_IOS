//
//  SocialUtils.m
//
//  Created by Ricky Lee on 1/2/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "SocialUtils.h"

#import "social/Social.h"
#import "accounts/Accounts.h"

@implementation SocialUtils
@synthesize delegate;
@synthesize viewController;

- (void)dealloc {
    [viewController release];
    [super dealloc];
}

#pragma mark - private
- (void)finishedSharingSocial:(BOOL)done {
    if (done) {
        [self createAlert];
    }
    else {
        if (delegate != nil && [delegate respondsToSelector:@selector(cancelSharingSocial)]) {
            [delegate performSelector:@selector(cancelSharingSocial) withObject:nil];
        }
    }
}

- (void)shareWithImage:(UIImage *)image withStyle:(NSString *)type {
        
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:type];
    [controller setInitialText:NSLocalizedString(@"SHARE_FROM_IRIS", nil)];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            NSLog(@"Cancelled");
            [self finishedSharingSocial:NO];
            
        } else
            
        {
            NSLog(@"Done");
            [self finishedSharingSocial:YES];
        }
        
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler =myBlock;
    
    //        [controller setInitialText:@""];
    //        [controller addURL:[NSURL URLWithString:@""]];
    //        [controller addImage:[UIImage imageNamed:@"fb.png"]];
    if (image) {
        [controller addImage:image];
    }
    
    [viewController presentViewController:controller animated:YES completion:Nil];
    

}

#pragma mark - global
- (void)shareFacebookWithImage:(UIImage *)image {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
         [self shareWithImage:image withStyle:SLServiceTypeFacebook];
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"CANNOT_SHARE_PHOTO", nil)
                                  message:NSLocalizedString(@"CHECK_FACEBOOK_ACCOUNT", nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)shareTwitterWithImage:(UIImage *)image {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        [self shareWithImage:image withStyle:SLServiceTypeTwitter];
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"CANNOT_SHARE_PHOTO", nil)
                                  message:NSLocalizedString(@"CHECK_TWITTER_ACCOUNT", nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];        
    }
}

- (void)shareSinaWithImage:(UIImage *)image {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        
        [self shareWithImage:image withStyle:SLServiceTypeSinaWeibo];
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"CANNOT_SHARE_PHOTO", nil)
                                  message:NSLocalizedString(@"CHECK_SINA_ACCOUNT", nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];        
    }
}

- (void)createAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"UPLOAD_COMPLETED", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
    [alert show];
    [alert release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [alertView dismissWithClickedButtonIndex:-1 animated:YES];
            if (delegate != nil && [delegate respondsToSelector:@selector(finishedSharingSocial)]) {
                [delegate performSelector:@selector(finishedSharingSocial) withObject:nil];
            }
            break;
        default:
            break;
    }
}

@end
