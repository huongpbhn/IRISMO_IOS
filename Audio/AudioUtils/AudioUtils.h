//
//  AudioUtils.h
//  IRISLibrary
//
//  Created by Ricky Lee on 1/2/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioUtils : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate, AVAudioSessionDelegate> {
    NSURL *soundFileURL;
}

@property (nonatomic, retain) NSURL *defaultFileURL;

- (void)startRecordingAudio:(NSString *)path;
- (void)stopRecordingAudio;
- (void)startPlayingAudio:(NSString *)path;
- (void)stopPlayingAudio;

#pragma mark - toggle
- (void)toggleRecordAudio:(NSString *)path;
- (void)togglePlaybackAudio:(NSString *)path;

@end
