//
//  VideoUtils.m
//  IRISLibrary
//
//  Created by Ricky Lee on 8/28/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "VideoUtils.h"

@interface VideoUtils() {
}

@end

@implementation VideoUtils

@synthesize videoURLString;
@synthesize moviePlayer;

- (id)initWithContentURL:(NSString *)urlStr {
    self = [super init];
    if (self) {
        videoURLString = urlStr;
    }
    
    return self;
}

- (void)dealloc {
    videoURLString = nil;
    moviePlayer = nil;
    [super dealloc];
}

- (void)createVideoAtView:(UIView *)view {
    NSURL *videoURL = [NSURL URLWithString:videoURLString];
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    self.moviePlayer = mp;
    [mp release];
    moviePlayer.shouldAutoplay = NO;    
    [moviePlayer prepareToPlay];
//    [moviePlayer setScalingMode:MPMovieScalingModeFill];
    [view addSubview:moviePlayer.view];
}

- (void)newVideo:(NSString *)urlStr {
    [moviePlayer setContentURL:[NSURL URLWithString:urlStr]];
    moviePlayer.shouldAutoplay = NO;
    [moviePlayer prepareToPlay];
}


// present full screen
- (void)presentVideo:(UIViewController *)viewController {
    NSURL *videoURL = [NSURL URLWithString:videoURLString];
    
    MPMoviePlayerViewController *movieViewPlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:videoURL];
    
    [viewController presentMoviePlayerViewControllerAnimated:movieViewPlayer];
    [movieViewPlayer release];
}

@end
