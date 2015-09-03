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

- (void)createVideoAtView:(UIView *)view {
    NSURL *videoURL = [NSURL URLWithString:videoURLString];
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    self.moviePlayer = mp;
    [mp release];
    moviePlayer.shouldAutoplay = NO;    
    [moviePlayer prepareToPlay];
//    [moviePlayer setScalingMode:MPMovieScalingModeFill];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
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

- (void) videoDidFinish:(NSNotification*)notification {

    NSLog(@"finished playing video");
    if ([delegate respondsToSelector:@selector(videoDidFinish)]) {
        [delegate videoDidFinish];
    }
}

@end
