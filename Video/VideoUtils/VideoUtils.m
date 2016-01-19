//
//  VideoUtils.m
//  IRISLibrary
//
//  Created by Ricky Lee on 8/28/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "VideoUtils.h"
#import "CheckSystem.h"

@interface VideoUtils() {
}

@end

@implementation VideoUtils

@synthesize delegate;
@synthesize videoURLString;
@synthesize moviePlayer;
@synthesize fullScreenView;

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
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
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
        if (SYSTEM_VERSION_EQUAL_TO(@"9.0")) {
            [moviePlayer setScalingMode:MPMovieScalingModeFill];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadStateChange:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:moviePlayer];
        
        [view addSubview:moviePlayer.view];
    }
    [self newVideo:videoURLString shouldAutoPlay:autoPlay];

}

- (void)newVideo:(NSString *)urlStr shouldAutoPlay:(BOOL)autoPlay {
//    [moviePlayer stop];
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

- (void)videoDidFinish:(NSNotification *)notification {

    NSLog(@"finished playing video: %@", notification);
    if ([delegate respondsToSelector:@selector(videoDidFinish)]) {
        [delegate videoDidFinish];
    }
}

- (void)loadStateChange:(NSNotification *)notification {
    if ([delegate respondsToSelector:@selector(finishedLoadingMovie:)]) {
        MPMoviePlayerController* playerController = notification.object;
        MPMovieLoadState mLoadState = playerController.loadState;
        if (mLoadState == 1) {
            [delegate finishedLoadingMovie:NO];
        }
        else if (mLoadState == 3) {
            [delegate finishedLoadingMovie:YES];
        }
    }
}

- (void)stopVideo {
    if (moviePlayer != nil) {
        [moviePlayer stop];
    }
}

- (MPMoviePlaybackState)moviePlayerPlaybackStateDidChange {
    
    MPMoviePlayerController *player = moviePlayer;
    if (player.playbackState == MPMoviePlaybackStatePlaying) { //playing
        NSLog(@"playing: %li", (long)MPMoviePlaybackStatePlaying);
        return MPMoviePlaybackStatePlaying;
    }
    else if (player.playbackState == MPMoviePlaybackStatePaused) { //paused
        NSLog(@"paused: %li", (long)MPMoviePlaybackStatePaused);
        return MPMoviePlaybackStatePaused;
    }
    else { //if (player.playbackState == MPMoviePlaybackStateStopped) { //stopped
        NSLog(@"stop: %li", (long)MPMoviePlaybackStateStopped);
        return MPMoviePlaybackStateStopped;
    }
    
}

- (void)createFullScreenAt:(UIView *)view {
    if (!fullScreenView) {
        fullScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
        fullScreenView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        fullScreenView.backgroundColor = [UIColor clearColor];
        fullScreenView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        [view addSubview:fullScreenView];
    }
    if (moviePlayer.view.superview) {
        [moviePlayer.view removeFromSuperview];
    }
//    [UIView animateWithDuration:0.4
//                          delay:0.2
//                        options: UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         moviePlayer.view.frame = CGRectMake(0.0f, 0.0f, fullScreenView.frame.size.height, fullScreenView.frame.size.width);
//                     }
//                     completion:^(BOOL finished){
//                         NSLog(@"Done!");
//                     }];
    moviePlayer.view.frame = CGRectMake(0.0f, 0.0f, fullScreenView.frame.size.height, fullScreenView.frame.size.width);
    [fullScreenView addSubview:moviePlayer.view];
    fullScreenView.hidden = NO;
}

- (void)returnToRegularScreenAt:(UIView *)view {
    if (moviePlayer.view.superview) {
        [moviePlayer.view removeFromSuperview];
    }
    if (fullScreenView) {
        fullScreenView.hidden = YES;
    }
    moviePlayer.view.frame = CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height);
    [view addSubview:moviePlayer.view];
}


@end
