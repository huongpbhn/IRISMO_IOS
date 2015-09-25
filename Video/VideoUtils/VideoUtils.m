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

@synthesize delegate;
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
    if (moviePlayer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
    }
    
    videoURLString = nil;
    moviePlayer = nil;
    [super dealloc];
}

- (void)createVideoAtView:(UIView *)view shouldAutoPlay:(BOOL)autoPlay {
    if (moviePlayer == nil) {
        MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] init];
        self.moviePlayer = mp;
        [mp release];
        
        [moviePlayer.view setFrame:view.bounds];
        [moviePlayer setScalingMode:MPMovieScalingModeFill];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer];
        [view addSubview:moviePlayer.view];
    }
    [self newVideo:videoURLString shouldAutoPlay:autoPlay];

}

- (void)newVideo:(NSString *)urlStr shouldAutoPlay:(BOOL)autoPlay {
    [moviePlayer stop];
    [moviePlayer setContentURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    moviePlayer.shouldAutoplay = autoPlay;
    [moviePlayer prepareToPlay];
}


// present full screen
- (void)presentVideo:(UIViewController *)viewController {
    NSURL *videoURL = [NSURL URLWithString:videoURLString];
    
    MPMoviePlayerViewController *movieViewPlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:videoURL];
    
    [viewController presentMoviePlayerViewControllerAnimated:movieViewPlayer];
    [movieViewPlayer release];
}

- (void) videoDidFinish:(NSNotification*)notification {

    NSLog(@"finished playing video");
    if ([delegate respondsToSelector:@selector(videoDidFinish)]) {
        [delegate videoDidFinish];
    }
}

@end
