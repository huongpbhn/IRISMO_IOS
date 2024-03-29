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
- (void)finishedLoadingMovie:(BOOL)loading;

@end

@interface VideoUtils : NSObject

@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

@property (nonatomic, retain) NSString *videoURLString;

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) UIView *fullScreenView;

- (void)createVideoAtView:(UIView *)view shouldAutoPlay:(BOOL)autoPlay;
- (void)newVideo:(NSString *)urlStr shouldAutoPlay:(BOOL)autoPlay;
- (void)stopVideo;
- (MPMoviePlaybackState)moviePlayerPlaybackStateDidChange;

// present full screen
- (void)presentVideo:(UIViewController *)viewController;

// custom full screen
- (void)createFullScreenAt:(UIView *)view withRadius:(CGFloat) radius;
- (void)returnToRegularScreenAt:(UIView *)view;

@end
