//
//  SocialUtils.h
//
//  Created by Ricky Lee on 1/2/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SocialUtilsDelegate <NSObject>

@optional
- (void)finishedSharingSocial;
- (void)cancelSharingSocial;

@end

@interface SocialUtils : NSObject <UIAlertViewDelegate>

@property (nonatomic, assign)id delegate;
@property (nonatomic, retain)UIViewController *viewController;

- (void)shareFacebookWithImage:(UIImage *)image;
- (void)shareTwitterWithImage:(UIImage *)image;
- (void)shareSinaWithImage:(UIImage *)image;

@end
