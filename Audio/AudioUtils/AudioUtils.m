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
    
    NSString *tempSoundFilePath;
}

@end

@implementation AudioUtils

- (id)init {
    self = [super init];
    if (self) {
        NSString *tempDir = NSTemporaryDirectory();
        tempSoundFilePath = [tempDir stringByAppendingString: RECORD_FILE_NAME];          // record audio
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        audioSession.delegate = self;
        [audioSession setActive:YES error:nil];
        
        recording = NO;
        playing = NO;
        
    }
    
    return self;
}

- (void)dealloc {
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

// record audio
- (void)startRecordingAudio {
    [self startRecordingAudio:tempSoundFilePath];
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
    if (!soundRecorder) {
        soundRecorder = [[AVAudioRecorder alloc] initWithURL: urlPath
                                                    settings: recordSettings
                                                       error: nil];
    }
    
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

// playing audio
- (void)startPlayback {
    [self startPlayingAudio:tempSoundFilePath];
}

- (void)startPlayingAudio:(NSString *)path {
    [[AVAudioSession sharedInstance]
     setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSURL *urlPath = [NSURL URLWithString:path];
    if (!soundPlayer) {
        soundPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:urlPath
                       error:nil];
    }
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
- (BOOL)toggleRecordAudio {
    return [self toggleRecordAudio:tempSoundFilePath];
}

- (BOOL)togglePlaybackAudio {
    return [self togglePlaybackAudio:tempSoundFilePath];
}

- (BOOL)toggleRecordAudio:(NSString *)path {
    if (recording) {
        recording = NO;
        [self stopRecordingAudio];
    } else {
        recording = YES;
        [self startRecordingAudio:path];
    }
    return recording;
    
}
- (BOOL)togglePlaybackAudio:(NSString *)path {
    if (playing) {
        playing = NO;
        [self stopPlayingAudio];
    } else {
        playing = YES;
        [self startPlayingAudio:path];
    }
    return playing;
}

@end
