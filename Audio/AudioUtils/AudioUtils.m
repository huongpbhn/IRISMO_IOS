//
//  AudioUtils.m
//
//  Created by Ricky Lee on 1/2/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "AudioUtils.h"

#define RECORD_DURATION 30.0f
#define RECORD_FILE_NAME @"audioUtils_default.wav"

@interface AudioUtils() {
    BOOL recording;
    BOOL playing;
    
    AVAudioRecorder *soundRecorder;
    AVAudioPlayer *soundPlayer;
}

@end

@implementation AudioUtils

@synthesize defaultFileURL;

- (id)init {
    self = [super init];
    if (self) {
        NSString *tempDir = NSTemporaryDirectory();
        NSString *soundFilePath = [tempDir stringByAppendingString: RECORD_FILE_NAME];          // record audio
        
        NSURL *temp = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        self.defaultFileURL = temp;
        [temp release];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        audioSession.delegate = self;
        [audioSession setActive:YES error:nil];
        
        recording = NO;
        playing = NO;
        
    }
    
    return self;
}

- (void)dealloc {
    self.defaultFileURL = nil;
    
    if (soundRecorder) {
        [soundRecorder release];
        soundRecorder = nil;
    }
    if (soundPlayer) {
        [soundPlayer release];
        soundPlayer = nil;
    }
    [super dealloc];
}

- (void)startRecordingAudio:(NSString *)path {
    [[AVAudioSession sharedInstance]
     setCategory:AVAudioSessionCategoryPlayAndRecord
     error: nil];
    
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:44100.0f], AVSampleRateKey,
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
                                    nil];
    
    NSURL *urlPath = [NSURL URLWithString:path];
    soundRecorder = [[AVAudioRecorder alloc] initWithURL: urlPath
                                                settings: recordSettings
                                                   error: nil];
    
    [recordSettings release];
    
    soundRecorder.delegate = self;
    [soundRecorder recordForDuration:RECORD_DURATION];

}

- (void)stopRecordingAudio {
    if (soundRecorder) {
        [soundRecorder stop];
        [soundRecorder release];
        soundRecorder = nil;
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
}

- (void)startPlayingAudio:(NSString *)path {
    [[AVAudioSession sharedInstance]
     setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSURL *urlPath = [NSURL URLWithString:path];
    soundPlayer = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:urlPath
                   error:nil];
    soundPlayer.delegate = self;
    [soundPlayer prepareToPlay];
    [soundPlayer play];
    soundPlayer.volume = 1.0;
}

- (void)stopPlayingAudio {
    if (soundPlayer) {
        [soundPlayer stop];

        [soundPlayer release];
        soundPlayer = nil;
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
}

#pragma mark - for toggle
- (void)toggleRecordAudio:(NSString *)path {
    if (recording) {
        recording = NO;
        [self stopRecordingAudio];
    } else {
        recording = YES;
        [self startRecordingAudio:path];
    }
    
}
- (void)togglePlaybackAudio:(NSString *)path {
    if (playing) {
        playing = NO;
        [self stopPlayingAudio];
    } else {
        playing = YES;
        [self startPlayingAudio:path];
    }
}

@end
