//
//  VideoUtils.h
//  IRISLibrary
//
//  Created by Ricky Lee on 8/28/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol VideoUtilsDelegate <NSObject>

@optional
- (void)videoDidFinish;

@end

@interface VideoUtils : NSObject

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

@property (nonatomic, retain) NSString *videoURLString;

@property (nonatomic, assign)id delegate;

- (void)createVideoAtView:(UIView *)view;
- (void)newVideo:(NSString *)urlStr;

// present full screen
- (void)presentVideo:(UIViewController *)viewController;

@end
